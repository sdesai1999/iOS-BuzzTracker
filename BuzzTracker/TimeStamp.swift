//
//  TimeStamp.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/27/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import Foundation

class TimeStamp {
    var date: Int
    var month: Int
    var day: Int
    var year: Int
    var hours: Int
    var minutes: Int
    var seconds: Int
    var nanos: Int
    var time: Int
    var timezoneOffset: Int
    
    init(aDate: Int, aMonth: Int, aDay: Int, aYear: Int, aHours: Int, aMinutes: Int, aSeconds: Int, aNanos: Int, aTime: Int, aOffset: Int) {
        date = aDate
        month = aMonth
        day = aDay
        year = aYear
        hours = aHours
        minutes = aMinutes
        seconds = aSeconds
        nanos = aNanos
        time = aTime
        timezoneOffset = aOffset
    }
}
