//
//  TimeStamp.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/27/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import Foundation

class TimeStamp {
    var month: Int
    var day: Int
    var year: Int
    var hours: Int
    var minutes: Int
    var seconds: Int
    
    init(aMonth: Int, aDay: Int, aYear: Int, aHours: Int, aMinutes: Int, aSeconds: Int) {
        month = aMonth
        day = aDay
        year = aYear
        hours = aHours
        minutes = aMinutes
        seconds = aSeconds
    }
}
