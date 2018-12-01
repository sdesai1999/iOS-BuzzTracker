//
//  LocationDetailViewController.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/22/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LocationDetailViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet var detailLabels: [UILabel]!
    @IBOutlet weak var addDonationButton: UIButton!
    @IBOutlet weak var viewDonationsButton: UIButton!
    
    
    var currLocation: Location? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barButtonFormat()
        addDonationButton.layer.cornerRadius = 9
        viewDonationsButton.layer.cornerRadius = 9
        
        if currUserType != UserType.locationEmployee {
            addDonationButton.isHidden = true
        }
        
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
        
        detailLabels[0].text = "NAME: \(currLocation!.name)"
        detailLabels[1].text = "TYPE: \(currLocation!.type)"
        detailLabels[2].text = "LONGITUDE: \(currLocation!.longitude)"
        detailLabels[3].text = "LATITUDE: \(currLocation!.latitude)"
        detailLabels[4].text = "ADDRESS: \(currLocation!.address)"
        detailLabels[5].text = "PHONE NUMBER: \(currLocation!.phoneNum)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DonationsListViewController {
            destination.currLocation = currLocation
        }
        
        if let destination = segue.destination as? AddDonationViewController {
            destination.currLocation = currLocation
        }
    }

}
