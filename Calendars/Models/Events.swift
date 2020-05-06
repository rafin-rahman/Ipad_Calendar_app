//
//  Event.swift
//  Calendars
//
//  Created by Rafin Rahman on 18/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import Foundation


class Events{
    var id = ""
    var eventName = ""
    var startDate = Date()
    var endDate = Date()
    var location = ""
    var reminder = Date()
    var priority = ""
    var profile = ""
    var profileColour = ""
    var allDay = false
    
    var numberOfCollision = 0
    var first = true
}