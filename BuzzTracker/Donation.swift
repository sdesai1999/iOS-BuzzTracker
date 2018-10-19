//
//  Donation.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/19/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import Foundation

class Donation {
    var date: Date
    var location: Location
    var shortDescription: String
    var fullDescripton: String
    var value: Int
    var category: DonationCategory
    // add comments and photo as extra credit later ???
    
    init(tmpDate: Date, tmpLoc: Location, tmpShort: String, tmpFull: String, tmpVal: Int, tmpCat: DonationCategory) {
        date = tmpDate
        location = tmpLoc
        shortDescription = tmpShort
        fullDescripton = tmpFull
        value = tmpVal
        category = tmpCat
    }
}
