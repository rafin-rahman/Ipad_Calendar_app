//
//  DayView.swift
//  Calendars
//
//  Created by Rafin Rahman on 12/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class DayView: UIView, UIScrollViewDelegate {
    
    let startTime = CGFloat(2)
    let endTime = CGFloat(4)
    
    let startTime2 = CGFloat(3)
    let endTime2 = CGFloat(5)
    
    let startTime3 = CGFloat(2)
    let endTime3 = CGFloat(3)
    
    
    
    @IBOutlet weak var leftScroll: UIScrollView!
    @IBOutlet weak var rightScroll: UIScrollView!
    
    @IBOutlet weak var stackView: UIStackView!

    var eventStartingList : Array<Event> = Array()
    var eventEndingList : Array<Event> = Array()
    var finalEventList : Array<Event> = Array()
        
    func getEventList(){
        let dbConnection = Firestore.firestore()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let start = calendar.date(from: components)!
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        
        let profileReference = dbConnection.collection("User").document("Subin").collection("Profile")
        
        profileReference.getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for profile in querySnapshot!.documents {
                    let eventStartingToday = profileReference.document(profile.documentID).collection("Events").whereField("EventStartTime", isGreaterThanOrEqualTo: start)
                    let eventEndingToday = profileReference.document(profile.documentID).collection("Events").whereField("EventEndTime", isLessThan: end)
                        
                    eventStartingToday.getDocuments(){
                        (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        }
                        else {
                            for event in querySnapshot!.documents {
                                let newEvent = Event()
                                
                                newEvent.id = (event.documentID)
                                
                                newEvent.eventName = event["EventName"] as! String
                                
                                if let convertedDate = event["EventStartTime"] as? Timestamp {
                                    newEvent.startDate = convertedDate.dateValue()
                                }
                                
                                if let convertedDate = event["EventEndTime"] as? Timestamp {
                                    newEvent.endDate = convertedDate.dateValue()
                                }
                                self.eventStartingList.append(newEvent)
                            }
                        }
                    }
                    
                    eventEndingToday.getDocuments(){
                        (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        }
                        else {
                            for event in querySnapshot!.documents {
                                let newEvent = Event()
                                
                                newEvent.id = (event.documentID)
                                
                                newEvent.eventName = event["EventName"] as! String
                                                               
                                if let convertedDate = event["EventStartTime"] as? Timestamp {
                                    newEvent.startDate = convertedDate.dateValue()
                                }
                                                               
                                if let convertedDate = event["EventEndTime"] as? Timestamp {
                                    newEvent.endDate = convertedDate.dateValue()
                                }
                                self.eventEndingList.append(newEvent)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getCurrentDaysEvent(){
        for startEvent in eventStartingList{
            for endEvent in eventEndingList{
                if startEvent.id == endEvent.id{
                    self.finalEventList.append(startEvent)
                }
            }
        }
    }
        
    func populateStackView() {
//        let event = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        event.backgroundColor = .brown
//        event.translatesAutoresizingMaskIntoConstraints = false
//        rightScroll.addSubview(event)
//        event.topAnchor.constraint(equalTo: rightScroll.topAnchor, constant: startTime * 60 ).isActive = true
//        event.leadingAnchor.constraint(equalTo: rightScroll.leadingAnchor, constant: 0).isActive = true
//        event.widthAnchor.constraint(equalToConstant: rightScroll.layer.bounds.width/2).isActive = true
//        event.heightAnchor.constraint(equalToConstant: endTime * 60 ).isActive = true
//
//        let eventTwo = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        eventTwo.backgroundColor = .blue
//        eventTwo.translatesAutoresizingMaskIntoConstraints = false
//        rightScroll.addSubview(eventTwo)
//        eventTwo.topAnchor.constraint(equalTo: rightScroll.topAnchor, constant: startTime2 * 60 ).isActive = true
//        eventTwo.leadingAnchor.constraint(equalTo: rightScroll.leadingAnchor, constant: rightScroll.frame.width/2).isActive = true
//        eventTwo.trailingAnchor.constraint(equalTo: rightScroll.trailingAnchor, constant: 0).isActive = true
//        eventTwo.widthAnchor.constraint(equalTo: rightScroll.widthAnchor).isActive = true
//        eventTwo.heightAnchor.constraint(equalToConstant: endTime2 * 60).isActive = true
        
        getEventList()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.getCurrentDaysEvent()
            
            
            for todaysEvent in self.finalEventList{
                let event = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                event.backgroundColor = .brown
                event.translatesAutoresizingMaskIntoConstraints = false
                self.rightScroll.addSubview(event)
                                     
                let startHour = CGFloat(Calendar.current.component(.hour, from: todaysEvent.startDate))
                let endHour = CGFloat(Calendar.current.component(.hour, from: todaysEvent.endDate))
                
                let startMinute = (CGFloat(Calendar.current.component(.minute, from: todaysEvent.startDate)))/60
                let endMinute = (CGFloat(Calendar.current.component(.minute, from: todaysEvent.endDate)))/60
                
                let finalStartTime = startHour+startMinute
                let finalEndTime = endHour+endMinute
                
                
                event.topAnchor.constraint(equalTo: self.rightScroll.topAnchor, constant: finalStartTime * 62 ).isActive = true
                event.leadingAnchor.constraint(equalTo: self.rightScroll.leadingAnchor, constant: 0).isActive = true
                event.widthAnchor.constraint(equalToConstant: self.rightScroll.layer.bounds.width).isActive = true
                event.heightAnchor.constraint(equalToConstant: (finalEndTime - finalStartTime) * 62 ).isActive = true
            }
        }
        	
    }
    
        
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           if scrollView == rightScroll {
               self.synchronizeScrollView(leftScroll, toScrollView: rightScroll)
           }
           else if scrollView == leftScroll {
               self.synchronizeScrollView(rightScroll, toScrollView: leftScroll)
           }
       }

       func synchronizeScrollView(_ scrollViewToScroll: UIScrollView, toScrollView scrolledView: UIScrollView) {
           var offset = scrollViewToScroll.contentOffset
           offset.y = scrolledView.contentOffset.y

           scrollViewToScroll.setContentOffset(offset, animated: false)
       }
    
   

}
