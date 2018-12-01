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
        self.barButtonFormat()
        
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
        
        detailLabels[0].text = "CATEGORY: \(currDonation!.category)"
        detailLabels[1].text = "FULL DESCRIPTION: \(currDonation!.fullDescripton)"
        detailLabels[2].text = "LOCATION: \(currLocation!.name)"
        detailLabels[3].text = "QUANTITY: \(currDonation!.number)"
        detailLabels[4].text = "SHORT DESCRIPTION: \(currDonation!.shortDescription)"
        detailLabels[6].text = "VALUE: \(currDonation!.value)"
        
        let timeStamp: TimeStamp = currDonation!.timestamp
        
        let yearStr = String(timeStamp.year)
        let start = yearStr.index(yearStr.startIndex, offsetBy: 1)
        let end = yearStr.index(yearStr.startIndex, offsetBy: 2)
        let yearSubstr = yearStr[start...end]
        
        var hourString: String = "\(timeStamp.hours)"
        var minuteString: String = "\(timeStamp.minutes)"
        var secondString: String = "\(timeStamp.seconds)"
        if timeStamp.hours < 10 {
            hourString = "0\(hourString)"
        }
        if timeStamp.minutes < 10 {
            minuteString = "0\(minuteString)"
        }
        if timeStamp.seconds < 10 {
            secondString = "0\(secondString)"
        }
        
        let timeMessage: String = "TIME STAMP: \(timeStamp.month)-\(timeStamp.date)-\(yearSubstr) \(hourString):\(minuteString):\(secondString)"
        detailLabels[5].text = timeMessage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DonationsListViewController {
            destination.currLocation = currLocation
            return
        }
    }

}
