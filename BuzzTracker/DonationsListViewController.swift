//
//  DonationsListViewController.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/27/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class DonationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = donationList[indexPath.row].shortDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedDonation = donationList[indexPath.row]
        self.performSegue(withIdentifier: "tappedOnDonationCell", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(red: 1.00032, green: 0.998127, blue: 0.923862, alpha: 1)
        cell.textLabel?.font = UIFont(name: "Avenir", size: 16)
    }
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var donationTableView: UITableView!
    
    var currLocation: Location? = nil
    var donationList: [Donation] = []
    var selectedDonation: Donation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barButtonFormat()
        self.donationTableView.separatorStyle = .none
        
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
        
        let ref = Database.database().reference()
        ref.child("donations").child(currLocation!.name).observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                var currDonationData: [Any] = []
                for newChild in snap.children {
                    let dataKey = newChild as! DataSnapshot
                    if dataKey.key == "timestamp" {
                        var timeData: [Int] = []
                        for timeElem in dataKey.children {
                            let elem = timeElem as! DataSnapshot
                            timeData.append(elem.value as! Int)
                        }
                        
                        let stamp = TimeStamp(aDate: timeData[0], aMonth: timeData[4], aDay: timeData[1], aYear: timeData[9], aHours: timeData[2],
                                              aMinutes: timeData[3], aSeconds: timeData[6], aNanos: timeData[5], aTime: timeData[7], aOffset: timeData[8])
                        currDonationData.append(stamp as Any)
                        continue
                    }
                    
                    currDonationData.append(dataKey.value as Any)
                }
                
                if let tempDonationType = currDonationData[0] as? String {
                    for donationType in DonationCategory.allCases {
                        if donationType.rawValue == tempDonationType {
                            currDonationData[0] = donationType.rawValue
                            break
                        }
                    }
                }
                
                let newDonation = Donation(tmpStamp: currDonationData[5] as! TimeStamp, tmpLoc: currDonationData[2] as! String, tmpShort: currDonationData[4] as! String,
                                           tmpFull: currDonationData[1] as! String, tmpVal: currDonationData[6] as! Double, tmpCat: currDonationData[0] as! String,
                                           tmpNum: currDonationData[3] as! Int)
                
                self.donationList.append(newDonation)
            }
            
            self.donationTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LocationDetailViewController {
            destination.currLocation = currLocation
            return
        }
        
        if let destination = segue.destination as? DonationDetailViewController {
            destination.currLocation = currLocation
            destination.currDonation = selectedDonation
            return
        }
    }

}
