//
//  SearchByCategoryViewController.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 11/4/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SearchByCategoryViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
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
    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet weak var categoryControl: UISegmentedControl!
    
    var locationList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SearchResultsViewController {
            destination.byCategory = true
            destination.locationToSearch = locationList[locationPicker.selectedRow(inComponent: 0)]
            let selec = categoryControl.selectedSegmentIndex
            switch selec {
                case 0: destination.searchedCategory = "CLOTHING"
                case 1: destination.searchedCategory = "HAT"
                case 2: destination.searchedCategory = "KITCHEN"
                case 3: destination.searchedCategory = "ELECTRONICS"
                case 4: destination.searchedCategory = "HOUSEHOLD"
                default: destination.searchedCategory = "OTHER"
            }
            destination.originVC = "cat"
        }
    }
}
