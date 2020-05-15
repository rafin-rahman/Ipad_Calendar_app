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
    var activeDate = Date()
    
    func equals (compareTo:Events) -> Bool {
         return
            self.id == compareTo.id &&
            self.eventName == compareTo.eventName &&
            self.startDate == compareTo.startDate &&
            self.endDate == compareTo.endDate &&
            self.location == compareTo.location &&
            self.reminder == compareTo.reminder &&
            self.priority == compareTo.priority &&
            self.profile == compareTo.profile &&
            self.profileColour == compareTo.profileColour &&
            self.allDay == compareTo.allDay
     }
}
