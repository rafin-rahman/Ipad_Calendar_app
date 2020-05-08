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
    
    var eventStartingList : Array<Events> = Array()
    var eventEndingList : Array<Events> = Array()
    var eventList : Array<Events> = Array()
    
    init() {
        dbConnection = Firestore.firestore()
    }
    
    func getAllEvents(){
        let eventReference = dbConnection.collection("User").document("Subin").collection("Event").whereField("DeleteStatus", isEqualTo: false)
        eventReference.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for event in querySnapshot!.documents {
                    
                    let newEvent = Events()
                    
                    newEvent.id = (event.documentID)
                    
                    newEvent.eventName = event["Name"] as! String
                    newEvent.location = event["Location"] as! String
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
    
    func getAllEventsForCurrentDay(){
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
                    
                    let newEvent = Events()
                    
                    newEvent.id = (event.documentID)
                    
                    newEvent.eventName = event["Name"] as! String
                    newEvent.location = event["Location"] as! String
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
    
    
    
    func getAllEventFromProfile(profileName:String){
        let eventReference = dbConnection.collection("User").document("Subin").collection("Event")
        
        let eventStartingToday = eventReference.whereField("Profile", isEqualTo: profileName)
        eventStartingToday.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for event in querySnapshot!.documents {
                    
                    let newEvent = Events()
                    
                    newEvent.id = (event.documentID)
                    
                    newEvent.eventName = event["Name"] as! String
                    newEvent.location = event["Location"] as! String
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
                    
                    let newEvent = Events()
                    
                    newEvent.id = (event.documentID)
                    
                    newEvent.eventName = event["Name"] as! String
                    newEvent.location = event["Location"] as! String
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
                    let newEvent = Events()
                    	
                    newEvent.id = (event.documentID)
                    
                    newEvent.eventName = event["Name"] as! String
                    newEvent.location = event["Location"] as! String
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
    
    func getEventFromDays() -> Array<Events>{
        var finalEventList : Array<Events> = Array()
        
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
    
    func editDeleteStatus(id:String, deleteStatus:Bool){
        let eventReference = dbConnection.collection("User").document("Subin").collection("Event").document(id)
        
        eventReference.updateData([
            "DeleteStatus": deleteStatus,
            "DeleteTime" : Date()
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func editEvent(updatedEvent:Events){
        print(updatedEvent.id)
        let eventReference = dbConnection.collection("User").document("Subin").collection("Event").document(updatedEvent.id)
        eventReference.updateData([
            "Name" : updatedEvent.eventName,
            "Location" : updatedEvent.location,
            "StartTime" : updatedEvent.startDate,
            "EndTime" : updatedEvent.endDate,
            "All-Day": updatedEvent.allDay,
            "ReminderTime" : updatedEvent.reminder,
            "Priority" : updatedEvent.priority,
            "Profile" : updatedEvent.profile,
            "ProfileColour" : updatedEvent.profileColour,
            "DeleteStatus" : false,
            "DeleteTime" : Date()
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        
    }
    
    func deleteEvent(eventId:String){
        let eventReference = dbConnection.collection("User").document("Subin").collection("Event")
        
        eventReference.document(eventId).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func getAllDeletedEventsFromDate(date:Date){
        let eventReference = dbConnection.collection("User").document("Subin").collection("Event")
        
        let deletedEvents = eventReference.whereField("DeleteStatus", isEqualTo: true).whereField("DeleteTime", isLessThan: date)
        deletedEvents.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for event in querySnapshot!.documents {
                    
                    let newEvent = Events()
                    
                    newEvent.id = (event.documentID)
                    
                    newEvent.eventName = event["Name"] as! String
                    newEvent.location = event["Location"] as! String
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
    
    func getAllDeletedEvents(){
        let eventReference = dbConnection.collection("User").document("Subin").collection("Event").order(by: "DeleteTime", descending: true)
        
        let deletedEvents = eventReference.whereField("DeleteStatus", isEqualTo: true)
        deletedEvents.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for event in querySnapshot!.documents {
                    
                    let newEvent = Events()
                    
                    newEvent.id = (event.documentID)
                    
                    newEvent.eventName = event["Name"] as! String
                    newEvent.location = event["Location"] as! String
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

