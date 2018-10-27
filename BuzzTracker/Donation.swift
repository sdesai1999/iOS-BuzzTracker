//
//  Donation.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/19/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import Foundation

class Donation {
    var timeStamp: TimeStamp
    var location: String
    var shortDescription: String
    var fullDescripton: String
    var value: Double
    var category: DonationCategory
    var number: Int
    // add comments and photo as extra credit later ???
    
    init(tmpStamp: TimeStamp, tmpLoc: String, tmpShort: String, tmpFull: String, tmpVal: Double, tmpCat: DonationCategory, tmpNum: Int) {
        timeStamp = tmpStamp
        location = tmpLoc
        shortDescription = tmpShort
        fullDescripton = tmpFull
        value = tmpVal
        category = tmpCat
        number = tmpNum
    }
}
