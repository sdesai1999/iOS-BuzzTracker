//
//  SearchResultsViewController.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 11/4/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        var cellLabel = ""
        switch numFound {
            case 0: cellLabel = "\(donationList[indexPath.row].shortDescription)"
            default: cellLabel = "\(donationList[indexPath.row].shortDescription): \(donationList[indexPath.row].location)"
        }
        cell.textLabel?.text = cellLabel
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(red: 1.00032, green: 0.998127, blue: 0.923862, alpha: 1)
        cell.textLabel?.font = UIFont(name: "Avenir", size: 16)
    }
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var donationTableView: UITableView!
    
    var donationList: [Donation] = []
    var selectedDonation: Donation? = nil
    var locationToSearch: String = ""
    var byCategory: Bool = false
    var searchedCategory: String = ""
    var searchedName: String = ""
    var originVC: String = ""
    var numFound: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        donationTableView.separatorStyle = .none
        self.barButtonFormat()
        
        donationList.append(Donation(tmpStamp: TimeStamp(aDate: 0, aMonth: 0, aDay: 0, aYear: 0, aHours: 0, aMinutes: 0, aSeconds: 0, aNanos: 0, aTime: 0, aOffset: 0),
                                     tmpLoc: "na", tmpShort: "No donation matches the search", tmpFull: "na", tmpVal: 0, tmpCat: "na", tmpNum: 0))
        donationTableView.beginUpdates()
        donationTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        donationTableView.endUpdates()
        
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
        
        if locationToSearch == "All" {
            globalSearch()
        } else {
            singleLocationSearch(locString: locationToSearch, single: true)
        }
    }
    
    func globalSearch() {
        let ref = Database.database().reference().child("donations")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                self.singleLocationSearch(locString: snap.key, single: false)
            }
        }
        
    }
    
    func singleLocationSearch(locString: String, single: Bool) {
        let ref = Database.database().reference().child("donations").child(locString)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                var currDonationData: [Any] = []
                var doSearch: Bool = false
                if !self.byCategory {
                    var sName = snap.childSnapshot(forPath: "shortDescription").value as! String
                    sName = sName.lowercased()
                    if sName.contains(self.searchedName.lowercased()) {
                        doSearch = true
                    }
                } else {
                    let sCat = snap.childSnapshot(forPath: "category").value as! String
                    if sCat == self.searchedCategory {
                        doSearch = true
                    }
                }
                
                if doSearch {
                    self.numFound += 1
                    if self.numFound == 1 {
                        self.donationList.remove(at: 0)
                        self.donationTableView.reloadData()
                    }
                    
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
            }
            
            self.donationTableView.reloadData()
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        if originVC == "cat" {
            self.performSegue(withIdentifier: "resultsToCategory", sender: self)
        } else {
            self.performSegue(withIdentifier: "resultsToName", sender: self)
        }
    }
    
}
