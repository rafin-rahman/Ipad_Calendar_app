//
//  Task.swift
//  Calendars
//
//  Created by Rafin Rahman on 03/05/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import Foundation

class Task{
    var id = ""
    var taskName = ""
    var taskDateAndTime = Date()
    var reminder = Date()
    var priority = ""
    var profile = ""
    var profileColour = ""
    var completedStatus = false
    
    var numberOfCollision = 0
    var first = true
    var activeDate = Date()
}
