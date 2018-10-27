//
//  DonationCategory.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/19/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//
// enum that defines the types of donations that can be made

import Foundation

enum DonationCategory: String, CaseIterable {
    case clothing = "CLOTHING"
    case hat = "HAT"
    case kitchen = "KITCHEN"
    case electronics = "ELECTRONICS"
    case household = "HOUSEHOLD"
    case other = "OTHER"
}
