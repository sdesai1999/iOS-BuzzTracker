//
//  DonationDetailViewController.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/27/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DonationDetailViewController: UIViewController {

    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet var detailLabels: [UILabel]!
    
    var currLocation: Location? = nil
    var currDonation: Donation? = nil
    
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
        
        detailLabels[0].text = "Category: \(currDonation!.category.rawValue)"
        detailLabels[1].text = "Full Description: \(currDonation!.fullDescripton)"
        detailLabels[2].text = "Location: \(currLocation!.name)"
        detailLabels[3].text = "Number: \(currDonation!.number)"
        detailLabels[4].text = "Short Description: \(currDonation!.shortDescription)"
        detailLabels[6].text = "Value: \(currDonation!.value)"
        
        let timeStamp: TimeStamp = currDonation!.timeStamp
        
        let yearStr = String(timeStamp.year)
        let start = yearStr.index(yearStr.startIndex, offsetBy: 1)
        let end = yearStr.index(yearStr.startIndex, offsetBy: 2)
        let yearSubstr = yearStr[start...end]
        
        let timeMessage: String = "Time Stamp: \(timeStamp.month)-\(timeStamp.day)-\(yearSubstr) \(timeStamp.hours):\(timeStamp.minutes):\(timeStamp.seconds)"
        detailLabels[5].text = timeMessage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DonationsListViewController {
            destination.currLocation = currLocation
            return
        }
    }

}