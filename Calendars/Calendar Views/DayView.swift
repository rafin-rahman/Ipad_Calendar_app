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

class DayView: UIView, CalendarProtocol, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var dayZero: UILabel!
    @IBOutlet weak var dayOneButton: UIButton!
    @IBOutlet weak var dayTwoButton: UIButton!
    @IBOutlet weak var dayThreeButton: UIButton!
    @IBOutlet weak var dayFourButton: UIButton!
    @IBOutlet weak var dayFiveButton: UIButton!
    @IBOutlet weak var daySixButton: UIButton!
    @IBOutlet weak var daySevenButton: UIButton!
    
    @IBOutlet weak var leftScroll: UIScrollView!
    @IBOutlet weak var rightScroll: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var eventAllDayView: UIView!
    
    var activeDate: Date = Date()
    
    var finalEventList : Array<Events> = Array()
    var finalAllDayEventList: Array<Events> = Array()
    
    var eventView : Array<UIView> = Array()
    var allDayListView : Array<UIView> = Array()
    
    @IBAction func prevWeek(_ sender: Any) {
        let date = dayZero.text!.toDate(dateFormat: "dd-MM-yy")!
        getDates(date: Calendar.current.date(byAdding: .day, value: -7, to: date)!)
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
           return true;
    }
    
    @IBAction func nextWeek(_ sender: Any) {
        let date = dayZero.text!.toDate(dateFormat: "dd-MM-yy")!
        getDates(date: Calendar.current.date(byAdding: .day, value: 7, to: date)!)
    }
    
    func getDailyView(eventDate:Date) {
        let eventDAO = EventDAO()
        let eventDAOForAllDay = EventDAO()
        
        self.clearAllDayEvent()
        self.clearView()
        
        dayOneButton.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.96, alpha: 1.00)
        dayOneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.getDates(date: Date())
        
        eventDAO.getEvents(eventDate: eventDate, allDayStatus: false)
        eventDAOForAllDay.getEvents(eventDate: eventDate, allDayStatus: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.finalAllDayEventList = eventDAOForAllDay.getEventFromDays()
            if(self.finalAllDayEventList.count > 0){
                self.displayAllDayEvents()
            }
            else{
                self.noAllDayEvent()
            }
                        
            self.finalEventList = eventDAO.getEventFromDays()
            if(self.finalEventList.count > 0)
            {
                EventCollision.collisionDetection(eventList: self.finalEventList)
                self.displayEvents()
            }
        }
    }
        
    func loadData() {
        getDailyViewForDate(eventDate: activeDate)
    }
    
    func getDailyViewForDate(eventDate:Date){
        let eventDAOForAllDay = EventDAO()
        let eventDAO = EventDAO()

        self.clearAllDayEvent()
        self.clearView()
        
        eventDAOForAllDay.getEvents(eventDate: eventDate, allDayStatus: true)
        eventDAO.getEvents(eventDate: eventDate, allDayStatus: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.finalAllDayEventList = eventDAOForAllDay.getEventFromDays()
            if(self.finalAllDayEventList.count > 0)
            {
                self.displayAllDayEvents()
            }
            else{
                self.noAllDayEvent()
            }
            
            self.finalEventList = eventDAO.getEventFromDays()
            if(self.finalEventList.count > 0)
            {
                EventCollision.collisionDetection(eventList: self.finalEventList)
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
        dayOneButton.setTitle(format.string(from: Calendar.current.date(byAdding: .day, value: 0, to: date)!), for: .normal)
        dayOneButton.tag = 0
        
        dayTwoButton.setTitle(format.string(from: Calendar.current.date(byAdding: .day, value: 1, to: date)!), for: .normal)
        dayTwoButton.tag = 1
        
        dayThreeButton.setTitle(format.string(from: Calendar.current.date(byAdding: .day, value: 2, to: date)!), for: .normal)
        dayThreeButton.tag = 2
        
        dayFourButton.setTitle(format.string(from: Calendar.current.date(byAdding: .day, value: 3, to: date)!), for: .normal)
        dayFourButton.tag = 3
        
        dayFiveButton.setTitle(format.string(from: Calendar.current.date(byAdding: .day, value: 4, to: date)!), for: .normal)
        dayFiveButton.tag = 4
        
        daySixButton.setTitle(format.string(from: Calendar.current.date(byAdding: .day, value: 5, to: date)!), for: .normal)
        daySixButton.tag = 5
        
        daySevenButton.setTitle(format.string(from: Calendar.current.date(byAdding: .day, value: 6, to: date)!), for: .normal)
        daySevenButton.tag = 6
    }
    
    func clearAllDayEvent(){
        for subview in self.allDayListView {
            subview.removeFromSuperview()
        }
    }
    
    func clearView(){
        for subview in self.eventView {
            subview.removeFromSuperview()
        }
    }
    
    //For all day event view
    func displayAllDayEvents(){
        if(self.finalAllDayEventList.count > 1)
        {
            
        }
        else{
            onlyOneAllDayEvent()
        }
    }
    
    func onlyOneAllDayEvent(){
        let allDayEvent = self.finalAllDayEventList[0]
            let eventName = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            let eventPriority = UIView(frame: CGRect(x: 0, y:0, width:0, height: 0))
            
            eventName.text = allDayEvent.eventName
            eventName.textColor = UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1)
            eventName.font = UIFont(name: "System", size: 17)
            
            self.eventAllDayView.backgroundColor = HexToUIColor.hexStringToUIColor(hex: allDayEvent.profileColour, alpha: 1.0)
            self.eventAllDayView.translatesAutoresizingMaskIntoConstraints = false
            eventName.translatesAutoresizingMaskIntoConstraints = false
            eventPriority.translatesAutoresizingMaskIntoConstraints = false
            
            self.allDayListView.append(eventName)
            self.allDayListView.append(eventPriority)
            self.eventAllDayView.addSubview(eventPriority)
            self.eventAllDayView.addSubview(eventName)
            
            eventPriority.topAnchor.constraint(equalTo: self.eventAllDayView.topAnchor, constant: 0).isActive = true
            eventPriority.leadingAnchor.constraint(equalTo: self.eventAllDayView.leadingAnchor, constant: 0).isActive = true
            eventPriority.heightAnchor.constraint(equalTo: self.eventAllDayView.heightAnchor, multiplier: 1).isActive = true
            eventPriority.widthAnchor.constraint(equalToConstant: 10).isActive = true
            
            eventPriority.backgroundColor = PriorityColorSelector.getColor(priority: allDayEvent.priority)
            
            eventName.topAnchor.constraint(equalTo: self.eventAllDayView.topAnchor, constant: 10).isActive = true
            eventName.leadingAnchor.constraint(equalTo: eventPriority.trailingAnchor, constant: 10).isActive = true
            eventName.trailingAnchor.constraint(equalTo: self.eventAllDayView.trailingAnchor, constant: -10).isActive = true
            eventName.bottomAnchor.constraint(equalTo: self.eventAllDayView.bottomAnchor, constant: -10).isActive = true
            eventName.numberOfLines = 0
            eventName.sizeToFit()
    }
    
    //for all day events if there are no events
    func noAllDayEvent(){
        let message = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
        
        message.text = "No All Day Event"
        message.textColor = UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1)
        message.font = UIFont(name: "System", size: 17)
        
        self.eventAllDayView.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "#EFF2F5", alpha: 1.0)
        self.eventAllDayView.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        
        self.allDayListView.append(message)
        self.eventAllDayView.addSubview(message)
        
        message.topAnchor.constraint(equalTo: self.eventAllDayView.topAnchor, constant: 10).isActive = true
        message.leadingAnchor.constraint(equalTo: self.eventAllDayView.leadingAnchor, constant: 20).isActive = true
        message.trailingAnchor.constraint(equalTo: self.eventAllDayView.trailingAnchor, constant: -10).isActive = true
        message.bottomAnchor.constraint(equalTo: self.eventAllDayView.bottomAnchor, constant: -10).isActive = true
        message.numberOfLines = 0
        message.sizeToFit()
    }
    
    func displayEvents(){
        eventView.removeAll()
        for todaysEvent in self.finalEventList{
            let event = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            let eventName = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            let eventPriority = UIView(frame: CGRect(x: 0, y:0, width:0, height: 0))
            
            let tapGesture = TapEventGesture(target: self, action: #selector(displayDetail(_:)))
            tapGesture.eventView = event
            tapGesture.event = todaysEvent
            tapGesture.delegate = self
            event.addGestureRecognizer(tapGesture)
            
            eventName.text = todaysEvent.eventName
            eventName.textColor = .white
            eventName.font = UIFont(name: "System", size: 17)
            
            let eventDuration = todaysEvent.endDate.timeIntervalSince(todaysEvent.startDate)
                        
            event.backgroundColor = SelectColor.getColor(color: todaysEvent.profileColour)
            event.translatesAutoresizingMaskIntoConstraints = false
            eventName.translatesAutoresizingMaskIntoConstraints = false
            eventPriority.translatesAutoresizingMaskIntoConstraints = false
            
            self.rightScroll.addSubview(event)
            self.eventView.append(event)
            
            let startHour = CGFloat(Calendar.current.component(.hour, from: todaysEvent.startDate))
            let endHour = CGFloat(Calendar.current.component(.hour, from: todaysEvent.endDate))
            
            let startMinute = (CGFloat(Calendar.current.component(.minute, from: todaysEvent.startDate)))/60
            let endMinute = (CGFloat(Calendar.current.component(.minute, from: todaysEvent.endDate)))/60
            
            let finalStartTime = startHour+startMinute
            let finalEndTime = endHour+endMinute
            
                    
            if(todaysEvent.numberOfCollision > 2){
                todaysEvent.numberOfCollision = 2;
            }
            
            if(todaysEvent.first){
                event.topAnchor.constraint(equalTo: self.rightScroll.topAnchor, constant: finalStartTime * 62).isActive = true
                event.leadingAnchor.constraint(equalTo: self.rightScroll.leadingAnchor, constant: 0).isActive = true
                event.widthAnchor.constraint(equalToConstant: self.rightScroll.layer.bounds.width/CGFloat(todaysEvent.numberOfCollision)).isActive = true
                                
                if eventDuration < 1300{
                    event.heightAnchor.constraint(equalToConstant:30).isActive = true
                }
                else{
                    event.heightAnchor.constraint(equalToConstant: (finalEndTime - finalStartTime) * 62).isActive = true
                }
            }
            else{
                event.topAnchor.constraint(equalTo: self.rightScroll.topAnchor, constant: finalStartTime * 62).isActive = true
                event.leadingAnchor.constraint(equalTo: self.rightScroll.leadingAnchor, constant: self.rightScroll.frame.width/2).isActive = true
                event.trailingAnchor.constraint(equalTo: self.rightScroll.trailingAnchor, constant: 0).isActive = true
                event.widthAnchor.constraint(equalToConstant: self.rightScroll.layer.bounds.width/CGFloat(todaysEvent.numberOfCollision)).isActive = true
                if eventDuration < 60{
                    event.heightAnchor.constraint(equalToConstant:30).isActive = true
                }
                else{
                    event.heightAnchor.constraint(equalToConstant: (finalEndTime - finalStartTime) * 62).isActive = true
                }
            }
           
            event.addSubview(eventPriority)
            event.addSubview(eventName)
            
            eventPriority.topAnchor.constraint(equalTo: event.topAnchor, constant: 0).isActive = true
            eventPriority.leadingAnchor.constraint(equalTo: event.leadingAnchor, constant: 0).isActive = true
            eventPriority.heightAnchor.constraint(equalTo: event.heightAnchor, multiplier: 1).isActive = true
            eventPriority.widthAnchor.constraint(equalToConstant: 10).isActive = true
            eventPriority.backgroundColor = PriorityColorSelector.getColor(priority: todaysEvent.priority)
        
            eventName.topAnchor.constraint(equalTo: event.topAnchor, constant: 10).isActive = true
            eventName.leadingAnchor.constraint(equalTo: eventPriority.trailingAnchor, constant: 10).isActive = true
            eventName.trailingAnchor.constraint(equalTo: event.trailingAnchor, constant: -10).isActive = true
            eventName.bottomAnchor.constraint(equalTo: event.bottomAnchor, constant: -10).isActive = true
            eventName.numberOfLines = 0
            eventName.sizeToFit()
            
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
    
    @objc func displayDetail(_ sender:TapEventGesture){
        
        //parent view -> sender.eventView
        if let detailsView = UINib(nibName: "DetailView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? DetailView {
            detailsView.translatesAutoresizingMaskIntoConstraints = false
            sender.eventView.addSubview(detailsView)
            
            detailsView.widthAnchor.constraint(equalToConstant: 400).isActive = true
            detailsView.heightAnchor.constraint(equalToConstant: 210).isActive = true
            
            let startHour = CGFloat(Calendar.current.component(.hour, from: sender.event.startDate))
            let endHour = CGFloat(Calendar.current.component(.hour, from: sender.event.endDate))
            
            let startMinute = (CGFloat(Calendar.current.component(.minute, from: sender.event.startDate)))/60
            let endMinute = (CGFloat(Calendar.current.component(.minute, from: sender.event.endDate)))/60
            
            let finalStartTime = (startHour+startMinute) * 62
            let finalEndTime = (endHour+endMinute) * 62
            
            print(finalStartTime)
            if finalStartTime < detailsView.bounds.height {
                detailsView.topAnchor.constraint(equalTo: sender.eventView.bottomAnchor, constant: 20).isActive = true
            } else {
                detailsView.bottomAnchor.constraint(equalTo: sender.eventView.topAnchor, constant: 20).isActive = true
            }
            detailsView.centerXAnchor.constraint(equalTo: sender.eventView.centerXAnchor).isActive = true
            
            rightScroll.scrollTo(event: sender.event, view: detailsView)
        }
    }
    
    @IBAction func daySelectedButtonClick(_ sender: UIButton) {
        dayOneButton.backgroundColor = UIColor.white
        dayTwoButton.backgroundColor = UIColor.white
        dayThreeButton.backgroundColor = UIColor.white
        dayFourButton.backgroundColor = UIColor.white
        dayFiveButton.backgroundColor = UIColor.white
        daySixButton.backgroundColor = UIColor.white
        daySevenButton.backgroundColor = UIColor.white
        
        dayOneButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        dayTwoButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        dayThreeButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        dayFourButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        dayFiveButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        daySixButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        daySevenButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        
        sender.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.96, alpha: 1.00)
        sender.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)

        let newFormat = DateFormatter()
        newFormat.dateFormat = "dd-MM-yy"
        let date = newFormat.date(from: dayZero.text!)
        let selectedDate = newFormat.string(from: Calendar.current.date(byAdding: .day, value: sender.tag, to: date!)!)
        activeDate = newFormat.date(from: selectedDate)!
        
        self.getDailyViewForDate(eventDate:newFormat.date(from: selectedDate)!)
        
    }
}
