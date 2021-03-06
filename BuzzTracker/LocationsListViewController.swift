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

class LocationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = locationList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedLocation = locationList[indexPath.row]
        self.performSegue(withIdentifier: "tappedOnCell", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(red: 1.00032, green: 0.998127, blue: 0.923862, alpha: 1)
        cell.textLabel?.font = UIFont(name: "Avenir", size: 16)
    }
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var locationsTableView: UITableView!
    
    var locationList: [Location] = []
    var selectedLocation: Location? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barButtonFormat()
        self.locationsTableView.separatorStyle = .none
        
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
                
                let newLoc = Location(tmpName: currLocData[3], tmpLat: currLocData[1], tmpLong: currLocData[2], tmpAddr: currLocData[0],
                                      tmpType: currLocData[5], tmpPhone: currLocData[4], tmpSite: currLocData[6])
                
                self.locationList.append(newLoc)
            }
            
            self.locationsTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LocationDetailViewController {
            destination.currLocation = selectedLocation
        }
        
        if let destination = segue.destination as? MapViewController {
            destination.locationList = self.locationList
        }
    }
}

extension UIViewController {
    func barButtonFormat() {
        let font: UIFont = UIFont(name: "Avenir", size: 17)!
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.classForCoder() as! UIAppearanceContainer.Type]).setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }
}
