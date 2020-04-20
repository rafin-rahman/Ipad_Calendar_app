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
    
    @IBOutlet weak var dayZero: UILabel!
    @IBOutlet weak var dayOne: UILabel!
    @IBOutlet weak var dayTwo: UILabel!
    @IBOutlet weak var dayThree: UILabel!
    @IBOutlet weak var dayFour: UILabel!
    @IBOutlet weak var dayFive: UILabel!
    @IBOutlet weak var daySix: UILabel!
    @IBOutlet weak var daySeven: UILabel!
    
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
    
    @IBAction func prevWeek(_ sender: Any) {
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yy"
        let date = format.date(from: dayZero.text!)!
        getDates(date: Calendar.current.date(byAdding: .day, value: -7, to: date)!)
        
    }
    
    @IBAction func nextWeek(_ sender: Any) {
        let format = DateFormatter()
               format.dateFormat = "dd-MM-yy"
               let date = format.date(from: dayZero.text!)!
               getDates(date: Calendar.current.date(byAdding: .day, value: 7, to: date)!)
    }
    
    func getDailyView() {
        self.getDates(date: Date())
        self.getEventList()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.getCurrentDaysEvent()
            
            if(self.finalEventList.count > 0)
            {
                self.detectCollisionForEvent()
                self.displayEvents()
            }
        }
    }
    
    func getDates(date:Date){
        let newFormat = DateFormatter()
        newFormat.dateFormat = "dd-MM-yy"
        
        let format = DateFormatter()
        format.dateFormat = "d E"
        
        
        dayZero.text = newFormat.string(from: Calendar.current.date(byAdding: .day, value: 0, to: date)!)
        dayOne.text = format.string(from: Calendar.current.date(byAdding: .day, value: 0, to: date)!)
        dayTwo.text = format.string(from: Calendar.current.date(byAdding: .day, value: 1, to: date)!)
        dayThree.text = format.string(from: Calendar.current.date(byAdding: .day, value: 2, to: date)!)
        dayFour.text = format.string(from: Calendar.current.date(byAdding: .day, value: 3, to: date)!)
        dayFive.text = format.string(from: Calendar.current.date(byAdding: .day, value: 4, to: date)!)
        daySix.text = format.string(from: Calendar.current.date(byAdding: .day, value: 5, to: date)!)
        daySeven.text = format.string(from: Calendar.current.date(byAdding: .day, value: 6, to: date)!)  
        
    }
    
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
                    
                    let eventEndingToday = profileReference.document(profile.documentID).collection("Events").whereField("EventEndTime", isLessThan: end)
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
    
    func displayEvents(){
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
            
            
            if(todaysEvent.first){
                event.topAnchor.constraint(equalTo: self.rightScroll.topAnchor, constant: finalStartTime * 62).isActive = true
                event.leadingAnchor.constraint(equalTo: self.rightScroll.leadingAnchor, constant: 0).isActive = true
                event.widthAnchor.constraint(equalToConstant: self.rightScroll.layer.bounds.width/2).isActive = true
                event.heightAnchor.constraint(equalToConstant: (finalEndTime - finalStartTime) * 62).isActive = true
            }
            else{
                event.topAnchor.constraint(equalTo: self.rightScroll.topAnchor, constant: finalStartTime * 62).isActive = true
                event.leadingAnchor.constraint(equalTo: self.rightScroll.leadingAnchor, constant: self.rightScroll.frame.width/2).isActive = true
                event.trailingAnchor.constraint(equalTo: self.rightScroll.trailingAnchor, constant: 0).isActive = true
                event.widthAnchor.constraint(equalToConstant: self.rightScroll.layer.bounds.width/2).isActive = true
                event.heightAnchor.constraint(equalToConstant: (finalEndTime - finalStartTime) * 62).isActive = true
            }
        }
    }
    
    func detectCollisionForEvent(){
        let length = self.finalEventList.count - 1
        
        for i in 0...length {
            let defaultEvent = self.finalEventList[i]
            for j in 0...length{
                let checkEvent = self.finalEventList[j]
                if(checkEvent.startDate > defaultEvent.startDate) && (checkEvent.endDate > defaultEvent.endDate) && (defaultEvent.endDate > checkEvent.startDate){
                    defaultEvent.numberOfCollision += 1
                    if(defaultEvent.first){
                        checkEvent.first = false
                        
                    }
                }
                else if(defaultEvent.startDate > checkEvent.startDate) && (defaultEvent.endDate > checkEvent.startDate) && (defaultEvent.startDate < checkEvent.endDate){
                    defaultEvent.numberOfCollision += 1
                    if(defaultEvent.first){
                        checkEvent.first = false
                        
                    }
                }
                else if(defaultEvent.startDate < checkEvent.startDate) && (defaultEvent.endDate > checkEvent.endDate){
                    defaultEvent.numberOfCollision += 1
                    if(defaultEvent.first){
                        checkEvent.first = false
                        
                    }
                    
                }
                else if(defaultEvent.startDate > checkEvent.startDate) && (defaultEvent.endDate < checkEvent.endDate){
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
    
    // Syncronize scroll views position
    func synchronizeScrollView(_ scrollViewToScroll: UIScrollView, toScrollView scrolledView: UIScrollView) {
        var offset = scrollViewToScroll.contentOffset
        offset.y = scrolledView.contentOffset.y
        
        scrollViewToScroll.setContentOffset(offset, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == rightScroll {
            self.synchronizeScrollView(leftScroll, toScrollView: rightScroll)
        }
        else if scrollView == leftScroll {
            self.synchronizeScrollView(rightScroll, toScrollView: leftScroll)
        }
    }
    
}
