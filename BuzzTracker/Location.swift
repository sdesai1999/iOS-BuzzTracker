//
//  Location.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/19/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import Foundation

class Location {
    var name: String
    var latitude: String
    var longitude: String
    var address: String
    var type: String
    var phoneNum: String
    var website: String
    var donations: [Donation] = []
    
    init(tmpName: String, tmpLat: String, tmpLong: String, tmpAddr: String, tmpType: String, tmpPhone: String, tmpSite: String, tmpDonations: [Donation]) {
        name = tmpName
        latitude = tmpLat
        longitude = tmpLong
        address = tmpAddr
        type = tmpType
        phoneNum = tmpPhone
        website = tmpSite
        donations.append(contentsOf: tmpDonations) // add the donations in tmpDonations to the current list of donations
    }
    
    convenience init(tmpName: String, tmpLat: String, tmpLong: String, tmpAddr: String, tmpType: String, tmpPhone: String, tmpSite: String) {
        let list: [Donation] = []
        self.init(tmpName: tmpName, tmpLat: tmpLat, tmpLong: tmpLong, tmpAddr: tmpAddr, tmpType: tmpType, tmpPhone: tmpPhone, tmpSite: tmpSite, tmpDonations: list)
    }
    
    func addDonation(donation: Donation) -> Void {
        donations.append(donation)
    }
}
