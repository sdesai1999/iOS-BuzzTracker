//
//  ViewController.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/5/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import UIKit

var currUserType: UserType = UserType.user // default value, can change later
// THESE ARE GLOBAL VARIABLES, TO TELL THE APP WHAT THE CURRENT USER IS

class ViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 9
        registerButton.layer.cornerRadius = 9
        print(self.view.backgroundColor)
    }
}

