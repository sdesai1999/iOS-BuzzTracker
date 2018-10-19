//
//  LocationEmployee.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/19/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import Foundation

class LocationEmployee: Person {
    var location: Location
    
    init(tmpName: String, tmpEmail: String, tmpPass: String, tmpType: UserType, tmpLoc: Location) {
        location = tmpLoc
        super.init(tmpName: tmpName, tmpEmail: tmpEmail, tmpPass: tmpPass, tmpType: tmpType)
    }
}
