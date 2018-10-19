//
//  Person.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/19/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//
// represents a user of the app... can be a user, admin, or location employee

import Foundation

class Person {
    var name: String
    var email: String
    var password: String
    var userType: UserType
    
    init(tmpName: String, tmpEmail: String, tmpPass: String, tmpType: UserType) {
        name = tmpName
        email = tmpEmail
        password = tmpPass
        userType = tmpType
    }
}
