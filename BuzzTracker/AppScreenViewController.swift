//
//  AppScreenViewController.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/22/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AppScreenViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet var actionButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in actionButtons {
            button.layer.cornerRadius = 9
        }
        
        emailLabel.text = Auth.auth().currentUser!.email
        
        let ref = Database.database().reference()
        ref.child("Users").child(Auth.auth().currentUser!.uid).child("userType").observeSingleEvent(of: .value, with: { (snapshot) in
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
        
        signOutButton.layer.cornerRadius = 5
    }

    @IBAction func signOutPressed(_ sender: Any) {
        currUserType = UserType.user
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "appScreenSignOut", sender: self)
    }
}
