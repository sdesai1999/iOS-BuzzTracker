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
    
    
    var currLocation: Location? = nil
    
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
        
        detailLabels[0].text = "Name: \(currLocation!.name)"
        detailLabels[1].text = "Type: \(currLocation!.type)"
        detailLabels[2].text = "Longitude: \(currLocation!.longitude)"
        detailLabels[3].text = "Latitude: \(currLocation!.latitude)"
        detailLabels[4].text = "Address: \(currLocation!.address)"
        detailLabels[5].text = "Phone Number: \(currLocation!.phoneNum)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DonationsListViewController {
            destination.currLocation = currLocation
        }
    }

}
