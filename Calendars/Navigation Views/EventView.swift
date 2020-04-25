//
//  EventViewController.swift
//  Calendars
//
//  Created by Rafin Rahman on 16/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class EventView: UIView, NavigationProtocol {

    var dynamicView: CalendarProtocol!
    
    func onLoad(){
        let eventDAO = EventDAO()
        eventDAO.getAllEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let listofEventsGroupedByDate = self.getEventsGroupedbyDate(eventList: eventDAO.eventList)
            let sortedEventDictonary = listofEventsGroupedByDate.sorted(by:{
                (key1:(String,Array<Event>), key2:(String,Array<Event>)) -> Bool in
                    key1.0 < key2.0
            })
            print(sortedEventDictonary)
            
            let listofEventsGroupedByProfile = self.getEventsGroupedbyProfile(eventList: eventDAO.eventList)
            print(listofEventsGroupedByProfile)
        }
    }
    
    func getEventsGroupedbyDate(eventList : Array<Event>) -> Dictionary<String, Array<Event>>{
        var eventDictonary : Dictionary <String, Array<Event>> = Dictionary()
        for event in eventList{
            let format = DateFormatter()
            format.dateFormat = "dd-MM-yyyy"
            let startDate = format.string(from: Calendar.current.date(byAdding: .day, value: 0, to: event.startDate)!)
            
            eventDictonary[startDate, default: []].append(event)
        }
       return eventDictonary
    }
    
    func getEventsGroupedbyProfile(eventList : Array<Event>) -> Dictionary<String, Array<Event>>{
        var eventDictonary : Dictionary <String, Array<Event>> = Dictionary()
        for event in eventList{
            eventDictonary[event.profile, default: []].append(event)
        }
        return eventDictonary
    }

}
