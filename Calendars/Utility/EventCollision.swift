//
//  EventCollision.swift
//  Calendars
//
//  Created by Rafin Rahman on 23/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import Foundation

class EventCollision{
    
    static func collisionDetection(eventList:Array<Events>)
    {
        let length = eventList.count - 1
        
        for i in 0...length {
            let defaultEvent = eventList[i]
            for j in 0...length{
                let checkEvent = eventList[j]
                
                if(checkEvent.startDate > defaultEvent.startDate) && (checkEvent.endDate > defaultEvent.endDate) && (defaultEvent.endDate > checkEvent.startDate){
                    defaultEvent.numberOfCollision += 1
                    if(defaultEvent.first){
                        checkEvent.first = false
                        
                    }
                }
                else if(defaultEvent.startDate > checkEvent.startDate) && (defaultEvent.endDate > checkEvent.endDate) && (defaultEvent.startDate < checkEvent.endDate){
                    defaultEvent.numberOfCollision += 1
                    if(defaultEvent.first){
                        checkEvent.first = false
                        
                    }
                }
                else if(defaultEvent.startDate == checkEvent.startDate) && (defaultEvent.endDate == checkEvent.endDate){
                    defaultEvent.numberOfCollision += 1
                }
                
            }
        }
    }
    
}
