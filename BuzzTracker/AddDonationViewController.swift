//
//  AddDonationViewController.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/28/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AddDonationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var fullDescriptionTextField: UITextField!
    @IBOutlet weak var shortDescriptionTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    
    var categories: [String] = []
    var currLocation: Location? = nil
    var activeTextField = UITextField()
    var currKeyboardHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupKeyboardStuff()
        for type in DonationCategory.allCases {
            categories.append(type.rawValue)
        }
        categoryPicker.reloadAllComponents()
        
        emailLabel.text = Auth.auth().currentUser!.email
        
        let ref1 = Database.database().reference()
        ref1.child("Users").child(Auth.auth().currentUser!.uid).child("userType").observeSingleEvent(of: .value, with: { (snapshot) in
            if let tempUserType = snapshot.value as? String {
                for type in UserType.allCases {
                    if type.rawValue == tempUserType {
                        currUserType = type
                        self.userTypeLabel.text = currUserType.rawValue
                        break
                    }
                }
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        fullDescriptionTextField.delegate = self
        shortDescriptionTextField.delegate = self
        numberTextField.delegate = self
        valueTextField.delegate = self
        
        fullDescriptionTextField.addTarget(self, action: #selector(textFieldWasTappedOn), for: UIControl.Event.touchDown)
        shortDescriptionTextField.addTarget(self, action: #selector(textFieldWasTappedOn), for: UIControl.Event.touchDown)
        numberTextField.addTarget(self, action: #selector(textFieldWasTappedOn), for: UIControl.Event.touchDown)
        valueTextField.addTarget(self, action: #selector(textFieldWasTappedOn), for: UIControl.Event.touchDown)
    }
    
    @IBAction func addDonationPressed(_ sender: Any) {
        enum Alerts: String {
            case FULLEMPTY = "Full description field is empty"
            case SHORTEMPTY = "Short description field is empty"
            case NUMEMPTY = "Number field is empty"
            case VALEMPTY = "Value field is empty"
            case NUMINVALID = "Number field must contain a valid integer"
            case VALINVALID = "Value field must contain a valid number"
        }
        
        var alertsList: [Alerts] = []
        var isValid: Bool = true
        let fullDescriptionText: String = fullDescriptionTextField.text!
        let shortDescriptionText: String = shortDescriptionTextField.text!
        let numberText: String = numberTextField.text!
        let valueText: String = valueTextField.text!
        
        if fullDescriptionText.count == 0 {
            isValid = false
            alertsList.append(Alerts.FULLEMPTY)
        }
        
        if shortDescriptionText.count == 0 {
            isValid = false
            alertsList.append(Alerts.SHORTEMPTY)
        }
        
        if numberText.count == 0 {
            isValid = false
            alertsList.append(Alerts.NUMEMPTY)
        }
        
        if valueText.count == 0 {
            isValid = false
            alertsList.append(Alerts.VALEMPTY)
        }
        
        let validNumber: Int? = Int(numberText)
        if validNumber == nil {
            isValid = false
            alertsList.append(Alerts.NUMINVALID)
        }
        
        let validValue: Double? = Double(valueText)
        if validValue == nil {
            isValid = false
            alertsList.append(Alerts.VALINVALID)
        }
        
        if !isValid {
            var alertMessage = ""
            for i in 0..<alertsList.count {
                alertMessage.append(contentsOf: alertsList[i].rawValue)
                if (i != (alertsList.count - 1)) {
                    alertMessage.append(contentsOf: ", ")
                }
            }
            
            let alert = UIAlertController(title: "Invalid Input", message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "e"
        let weekday: Int = Int(dateFormatter.string(from: date))!
        dateFormatter.dateFormat = "d"
        let monthday: Int = Int(dateFormatter.string(from: date))!
        dateFormatter.dateFormat = "MM"
        let month: Int = Int(dateFormatter.string(from: date))!
        dateFormatter.dateFormat = "yy"
        let year1: Int = Int(dateFormatter.string(from: date))!
        let year = year1 + 100
        let timeInMillis = Int(date.timeIntervalSince1970 * 10000)
        let timezoneOffset: Int = 240
        let nanos: Int = 731000000
        dateFormatter.dateFormat = "HH"
        let hour = Int(dateFormatter.string(from: date))!
        dateFormatter.dateFormat = "mm"
        let minute = Int(dateFormatter.string(from: date))!
        dateFormatter.dateFormat = "ss"
        let second = Int(dateFormatter.string(from: date))!
        
        let selectedCategory = categories[categoryPicker.selectedRow(inComponent: 0)]
        
        let timestamp: TimeStamp = TimeStamp(aDate: monthday, aMonth: month, aDay: weekday, aYear: year, aHours: hour, aMinutes: minute,
                                             aSeconds: second, aNanos: nanos, aTime: timeInMillis, aOffset: timezoneOffset)
        
        let donation: Donation = Donation(tmpStamp: timestamp, tmpLoc: currLocation!.name, tmpShort: shortDescriptionText,
                                          tmpFull: fullDescriptionText, tmpVal: validValue!, tmpCat: selectedCategory, tmpNum: validNumber!)
        
        var ref = Database.database().reference().child("donations").child(donation.location).childByAutoId()
        ref.child("category").setValue(selectedCategory)
        ref.child("fullDescription").setValue(fullDescriptionText)
        ref.child("location").setValue(donation.location)
        ref.child("locationName").setValue(currLocation!.name) // same as above
        ref.child("number").setValue(validNumber!)
        ref.child("shortDescription").setValue(shortDescriptionText)
        ref.child("value").setValue(validValue!)

        ref = ref.child("timestamp")
        ref.child("date").setValue(timestamp.date)
        ref.child("day").setValue(timestamp.day)
        ref.child("hours").setValue(timestamp.hours)
        ref.child("minutes").setValue(timestamp.minutes)
        ref.child("month").setValue(timestamp.month)
        ref.child("nanos").setValue(timestamp.nanos)
        ref.child("seconds").setValue(timestamp.seconds)
        ref.child("time").setValue(timestamp.time)
        ref.child("timezoneOffset").setValue(timestamp.timezoneOffset)
        ref.child("year").setValue(timestamp.year)
        
        self.performSegue(withIdentifier: "addDonationToLocationsList", sender: self)
    }
    
    @objc func textFieldWasTappedOn(textField: UITextField) {
        activeTextField = textField
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                currKeyboardHeight = keyboardSize.height
                let textFieldY = activeTextField.frame.origin.y
                if currKeyboardHeight < textFieldY {
                    self.view.frame.origin.y -= currKeyboardHeight
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y += currKeyboardHeight
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LocationDetailViewController {
            destination.currLocation = currLocation
        }
    }

}
