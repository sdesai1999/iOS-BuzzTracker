//
//  LocationsListViewController.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/22/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class LocationsListViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    
    var locationList: [Location] = []
    
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

        let locationRef = Database.database().reference()
        locationRef.child("Locations").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                var currLocData: [String] = []
                for newChild in snap.children {
                    let dataKey = newChild as! DataSnapshot
                    currLocData.append(dataKey.value as! String)
                }
                
                let newLoc = Location(tmpName: currLocData[3], tmpLat: currLocData[1], tmpLong: currLocData[2], tmpAddr: currLocData[0], tmpType: currLocData[5], tmpPhone: currLocData[4], tmpSite: currLocData[6])
                
                self.locationList.append(newLoc)
            }
            
            for location in self.locationList {
                print(location.address)
            }
        }
    }
}
