//
//  SearchByNameViewController.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 11/4/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SearchByNameViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locationList[row]
    }
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationPicker: UIPickerView!
    
    var activeTextField = UITextField()
    var currKeyboardHeight: CGFloat = 0.0
    var locationList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupKeyboardStuff()
        
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
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldWasTappedOn), for: UIControl.Event.touchDown)
        
        locationList.append("All")
        ref1.child("donations").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let name = snap.key
                self.locationList.append(name)
            }
            self.locationPicker.reloadAllComponents()
        }
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

}
