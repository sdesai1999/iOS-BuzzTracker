//
//  UserType.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/19/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//
// enum that defines the type of the person logged into the app

import Foundation

enum UserType: String, CaseIterable {
    case user = "USER"
    case admin = "ADMIN"
    case locationEmployee = "LOCATION EMPLOYEE"
}
