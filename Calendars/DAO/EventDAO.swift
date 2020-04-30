//
//  EventDAO.swift
//  Calendars
//
//  Created by Rafin Rahman on 23/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class EventDAO{
    let dbConnection:Firestore
    
    var eventStartingList : Array<Event> = Array()
    var eventEndingList : Array<Event> = Array()
    var eventList : Array<Event> = Array()
    
    init() {
        dbConnection = Firestore.firestore()
    }
    
    func getAllEvents(){
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let start = calendar.date(from: components)!
        
        let eventReference = dbConnection.collection("User").document("Subin").collection("Event")
        
        let eventStartingToday = eventReference.whereField("StartTime", isGreaterThanOrEqualTo: start).whereField("DeleteStatus", isEqualTo: false)
        eventStartingToday.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for event in querySnapshot!.documents {
                    
                    let newEvent = Event()
                    
                    newEvent.id = (event.documentID)
                    
                    newEvent.eventName = event["Name"] as! String
                    newEvent.allDay = event["All-Day"] as! Bool
                    newEvent.priority = event["Priority"] as! String
                    newEvent.profile = event["Profile"] as! String
                    newEvent.profileColour = event["ProfileColour"] as! String
                    
                    if let convertedDate = event["StartTime"] as? Timestamp {
                        newEvent.startDate = convertedDate.dateValue()
                    }
                    
                    if let convertedDate = event["EndTime"] as? Timestamp {
                        newEvent.endDate = convertedDate.dateValue()
                    }
                    
                    if let convertedDate = event["ReminderTime"] as? Timestamp{
                        newEvent.reminder = convertedDate.dateValue()
                    }
                    
                    self.eventList.append(newEvent)
                }
            }
        }
    }
    
    func getEvents(eventDate:Date, allDayStatus:Bool){
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: eventDate)
        let start = calendar.date(from: components)!
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        
        let eventReference = dbConnection.collection("User").document("Subin").collection("Event")
        
        let eventStartingToday = eventReference.whereField("StartTime", isGreaterThanOrEqualTo: start).whereField("All-Day", isEqualTo: allDayStatus).whereField("DeleteStatus", isEqualTo: false)
        eventStartingToday.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for event in querySnapshot!.documents {
                    
                    let newEvent = Event()
                    
                    newEvent.id = (event.documentID)
                    
                    newEvent.eventName = event["Name"] as! String
                    newEvent.allDay = event["All-Day"] as! Bool
                    newEvent.priority = event["Priority"] as! String
                    newEvent.profile = event["Profile"] as! String
                    newEvent.profileColour = event["ProfileColour"] as! String
                    
                    if let convertedDate = event["StartTime"] as? Timestamp {
                        newEvent.startDate = convertedDate.dateValue()
                    }
                    
                    if let convertedDate = event["EndTime"] as? Timestamp {
                        newEvent.endDate = convertedDate.dateValue()
                    }
                    
                    if let convertedDate = event["ReminderTime"] as? Timestamp{
                        newEvent.reminder = convertedDate.dateValue()
                    }
                    
                    self.eventStartingList.append(newEvent)
                }
            }
        }
        
        let eventEndingToday = eventReference.whereField("EndTime", isLessThan: end).whereField("All-Day", isEqualTo: allDayStatus).whereField("DeleteStatus", isEqualTo: false)
        eventEndingToday.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for event in querySnapshot!.documents {
                    let newEvent = Event()
                    	
                    newEvent.id = (event.documentID)
                    
                    newEvent.eventName = event["Name"] as! String
                    newEvent.allDay = event["All-Day"] as! Bool
                    newEvent.priority = event["Priority"] as! String
                    newEvent.profile = event["Profile"] as! String
                    newEvent.profileColour = event["ProfileColour"] as! String
                    
                    if let convertedDate = event["StartTime"] as? Timestamp {
                        newEvent.startDate = convertedDate.dateValue()
                    }
                    
                    if let convertedDate = event["EndTime"] as? Timestamp {
                        newEvent.endDate = convertedDate.dateValue()
                    }
                    
                    if let convertedDate = event["ReminderTime"] as? Timestamp{
                        newEvent.reminder = convertedDate.dateValue()
                    }
                    
                    self.eventEndingList.append(newEvent)
                }
            }
        }
    }
    
    func getEventFromDays() -> Array<Event>{
        var finalEventList : Array<Event> = Array()
        
        for startEvent in self.eventStartingList{
            for endEvent in self.eventEndingList{
                if startEvent.id == endEvent.id{
                    finalEventList.append(startEvent)
                }
            }
        }
        return finalEventList
    }
    
    func addNewEvent(eventDict:Dictionary<String, Any>){
        let eventReference = dbConnection.collection("User").document("Subin").collection("Event")
        let newEvent = eventReference.document()
        newEvent.setData(eventDict);
    }
    
    func getAllDeletedEvents(){
        let eventReference = dbConnection.collection("User").document("Subin").collection("Event")
        
        let deletedEvents = eventReference.whereField("DeleteStatus", isEqualTo: true)
        deletedEvents.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for event in querySnapshot!.documents {
                    
                    let newEvent = Event()
                    
                    newEvent.id = (event.documentID)
                    
                    newEvent.eventName = event["Name"] as! String
                    newEvent.allDay = event["All-Day"] as! Bool
                    newEvent.priority = event["Priority"] as! String
                    newEvent.profile = event["Profile"] as! String
                    newEvent.profileColour = event["ProfileColour"] as! String
                    
                    if let convertedDate = event["StartTime"] as? Timestamp {
                        newEvent.startDate = convertedDate.dateValue()
                    }
                    
                    if let convertedDate = event["EndTime"] as? Timestamp {
                        newEvent.endDate = convertedDate.dateValue()
                    }
                    
                    if let convertedDate = event["ReminderTime"] as? Timestamp{
                        newEvent.reminder = convertedDate.dateValue()
                    }
                    
                    self.eventList.append(newEvent)
                }
            }
        }
    }
}

