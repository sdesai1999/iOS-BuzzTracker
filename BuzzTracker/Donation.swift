//
//  Donation.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/19/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import Foundation

class Donation {
    var timestamp: TimeStamp
    var location: String
    var shortDescription: String
    var fullDescripton: String
    var value: Double
    var category: String
    var number: Int
    // add comments and photo as extra credit later ???
    
    init(tmpStamp: TimeStamp, tmpLoc: String, tmpShort: String, tmpFull: String, tmpVal: Double, tmpCat: String, tmpNum: Int) {
        timestamp = tmpStamp
        location = tmpLoc
        shortDescription = tmpShort
        fullDescripton = tmpFull
        value = tmpVal
        category = tmpCat
        number = tmpNum
    }
}
