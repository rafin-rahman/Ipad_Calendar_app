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
    @IBOutlet weak var taskBarView: UIView!
    
    
    var activeDate: Date = Date()
    
    var finalEventList : Array<Events> = Array()
    var finalAllDayEventList: Array<Events> = Array()
    
    var eventView : Array<UIView> = Array()
    var allDayListView : Array<UIView> = Array()
    var taskView:Array<UIView> = Array()
    
    var savedGestureEvent : EventGestureRecognizer!
    var savedGestureTask : TaskGestureRecognizer!
    
    var activeSearchPanel : SearchPanelViewController!
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    func unselectButton(){
        dayOneButton.backgroundColor = UIColor.white
        dayTwoButton.backgroundColor = UIColor.white
        dayThreeButton.backgroundColor = UIColor.white
        dayFourButton.backgroundColor = UIColor.white
        dayFiveButton.backgroundColor = UIColor.white
        daySixButton.backgroundColor = UIColor.white
        daySevenButton.backgroundColor = UIColor.white
        
        dayOneButton.titleLabel?.font = UIFont.init(name: "System", size: 5)
        dayTwoButton.titleLabel?.font = UIFont.init(name: "System", size: 5)
        dayThreeButton.titleLabel?.font = UIFont.init(name: "System", size: 5)
        dayFourButton.titleLabel?.font = UIFont.init(name: "System", size: 5)
        dayFiveButton.titleLabel?.font = UIFont.init(name: "System", size: 5)
        daySixButton.titleLabel?.font = UIFont.init(name: "System", size: 5)
        daySevenButton.titleLabel?.font = UIFont.init(name: "System", size: 5)
        
        
    }
    
    @IBAction func prevWeek(_ sender: Any) {
        unselectButton()
        let date = dayZero.text!.toDate(dateFormat: "dd-MM-yy")!
        getDates(date: Calendar.current.date(byAdding: .day, value: -7, to: date)!)
        
    }
    
    @IBAction func nextWeek(_ sender: Any) {
        unselectButton()
        let date = dayZero.text!.toDate(dateFormat: "dd-MM-yy")!
        getDates(date: Calendar.current.date(byAdding: .day, value: 7, to: date)!)
    }
    
    func loadData() {
        getDailyView(eventDate: activeDate)
    }
    
    func getDailyView(eventDate:Date){
        let eventDAOForAllDay = EventDAO()
        let eventDAO = EventDAO()
        let taskDAO = TaskDAO()
                
        getDates(date: eventDate)
        getHighlightedDate(selectedDate:eventDate)
        
        self.clearAllDayEvent()
        self.clearView()
        self.clearAllTask()
        
        eventDAOForAllDay.getEvents(eventDate: eventDate, allDayStatus: true)
        eventDAO.getEvents(eventDate: eventDate, allDayStatus: false)
        taskDAO.getAllTasksFromDays(startDate: eventDate.stripTime(), endDate: Calendar.current.date(byAdding: .day, value: 1, to: eventDate.stripTime())!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.finalAllDayEventList = eventDAOForAllDay.getEventFromDays()
            if(self.finalAllDayEventList.count > 0)
            {
                self.displayAllDayEvents()
            }
            else{
                self.noAllDayEvent()
            }
            
            if taskDAO.taskList.count > 0 {
                
                self.getListOfTask(tasks: taskDAO.taskList)
            }
            else{
                self.noTask()
            }
            
            self.finalEventList = eventDAO.getEventFromDays()
            if(self.finalEventList.count > 0)
            {
                EventCollision.collisionDetection(eventList: self.finalEventList)
                self.displayEvents()
            }
        }
    }
    
    func getDailyViewForDate(eventDate:Date){
        let eventDAOForAllDay = EventDAO()
        let eventDAO = EventDAO()
        let taskDAO = TaskDAO()
        
        self.clearAllDayEvent()
        self.clearView()
        self.clearAllTask()
        
        getHighlightedDate(selectedDate:eventDate)
        
        eventDAOForAllDay.getEvents(eventDate: eventDate, allDayStatus: true)
        eventDAO.getEvents(eventDate: eventDate, allDayStatus: false)
        taskDAO.getAllTasksFromDays(startDate: eventDate.stripTime(), endDate: Calendar.current.date(byAdding: .day, value: 1, to: eventDate.stripTime())!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.finalAllDayEventList = eventDAOForAllDay.getEventFromDays()
            if(self.finalAllDayEventList.count > 0)
            {
                self.displayAllDayEvents()
            }
            else{
                self.noAllDayEvent()
            }
            
            if taskDAO.taskList.count > 0 {
                self.getListOfTask(tasks: taskDAO.taskList)
            }
            else{
                self.noTask()
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
    
    func clearAllTask(){
        for subview in self.taskView {
            subview.removeFromSuperview()
        }
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
    
    func noTask(){
        if savedGestureTask != nil {
            taskBarView.removeGestureRecognizer(savedGestureTask)
        }
        let message = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
        
        message.text = "No Task Scheduled"
        
        message.textColor = UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1)
        message.font = UIFont.systemFont(ofSize: 17)
        
        self.taskBarView.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "#EFF2F5", alpha: 1.0)
        self.taskBarView.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        
        self.taskView.append(message)
        self.taskBarView.addSubview(message)
        
        message.topAnchor.constraint(equalTo: self.taskBarView.topAnchor, constant: 10).isActive = true
        message.leadingAnchor.constraint(equalTo: self.taskBarView.leadingAnchor, constant: 20).isActive = true
        message.trailingAnchor.constraint(equalTo: self.taskBarView.trailingAnchor, constant: -10).isActive = true
        message.bottomAnchor.constraint(equalTo: self.taskBarView.bottomAnchor, constant: -10).isActive = true
        message.numberOfLines = 0
    }
    
    func getListOfTask(tasks:Array<Task>){
        if savedGestureTask != nil {
            taskBarView.removeGestureRecognizer(savedGestureTask)
        }
        
        
        var counter = 0
        for task in tasks{
            if !task.completedStatus{
                counter += 1
            }
        }
        
        let message = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
        
        message.text = String(counter)+" out of "+String(tasks.count)+" Task To-do"
        message.textColor = .white
        message.font = UIFont.systemFont(ofSize: 17)
        
        let tapGesture = TaskGestureRecognizer(target: self, action: #selector(displayTaskListOfDetail(_:)))
        tapGesture.taskList = tasks
        tapGesture.delegate = self
        savedGestureTask = tapGesture
        taskBarView.addGestureRecognizer(tapGesture)
                        
        self.taskBarView.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "#8395a7", alpha: 1.0)
        self.taskBarView.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        
        self.taskView.append(message)
        self.taskBarView.addSubview(message)
                
        message.topAnchor.constraint(equalTo: self.taskBarView.topAnchor, constant: 10).isActive = true
        message.leadingAnchor.constraint(equalTo: self.taskBarView.leadingAnchor, constant: 20).isActive = true
        message.trailingAnchor.constraint(equalTo: self.taskBarView.trailingAnchor, constant: -10).isActive = true
        message.bottomAnchor.constraint(equalTo: self.taskBarView.bottomAnchor, constant: -10).isActive = true
        message.numberOfLines = 0
    }
    
    //For all day event view
    func displayAllDayEvents(){
        if(self.finalAllDayEventList.count > 1)
        {
            displayListOfAllDayEvent()
        }
        else{
            onlyOneAllDayEvent()
        }
    }
    
    func displayListOfAllDayEvent(){
        if savedGestureEvent != nil {
            eventAllDayView.removeGestureRecognizer(savedGestureEvent)
        }
        
        let message = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
        
        message.text = String(finalAllDayEventList.count) + " All Day Event"
        message.textColor = .white
        message.font = UIFont.systemFont(ofSize: 17)
        
        let tapGesture = EventGestureRecognizer(target: self, action: #selector(displayAllDayListOfDetail(_:)))
        tapGesture.delegate = self
        tapGesture.listOfAllDayEvents = finalAllDayEventList
        savedGestureEvent = tapGesture
        eventAllDayView.addGestureRecognizer(tapGesture)
        
        self.eventAllDayView.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "#576574", alpha: 1.0)
        self.eventAllDayView.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        
        self.allDayListView.append(message)
        self.eventAllDayView.addSubview(message)
        
        
        message.topAnchor.constraint(equalTo: self.eventAllDayView.topAnchor, constant: 10).isActive = true
        message.leadingAnchor.constraint(equalTo: self.eventAllDayView.leadingAnchor, constant: 20).isActive = true
        message.trailingAnchor.constraint(equalTo: self.eventAllDayView.trailingAnchor, constant: -10).isActive = true
        message.bottomAnchor.constraint(equalTo: self.eventAllDayView.bottomAnchor, constant: -10).isActive = true
        message.numberOfLines = 0
    }
    
    func onlyOneAllDayEvent(){
        if savedGestureEvent != nil {
            eventAllDayView.removeGestureRecognizer(savedGestureEvent)
        }
        let allDayEvent = self.finalAllDayEventList[0]
        let eventName = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
        let eventPriority = UIView(frame: CGRect(x: 0, y:0, width:0, height: 0))
        
        eventName.text = allDayEvent.eventName
        eventName.textColor = .white
        eventName.font = UIFont(name: "System", size: 17)
        
        eventAllDayView.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "#576574", alpha: 1)
        self.eventAllDayView.translatesAutoresizingMaskIntoConstraints = false
        eventName.translatesAutoresizingMaskIntoConstraints = false
        eventPriority.translatesAutoresizingMaskIntoConstraints = false
        
        self.allDayListView.append(eventName)
        self.allDayListView.append(eventPriority)
        self.eventAllDayView.addSubview(eventPriority)
        self.eventAllDayView.addSubview(eventName)
        
        let tapGesture = EventGestureRecognizer(target: self, action: #selector(displayDetail(_:)))
        tapGesture.event = allDayEvent
        tapGesture.delegate = self
         savedGestureEvent = tapGesture
        eventAllDayView.addGestureRecognizer(tapGesture)
                
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
        if savedGestureEvent != nil {
            eventAllDayView.removeGestureRecognizer(savedGestureEvent)
        }
        let message = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
        
        message.text = "No Event Scheduled"
        
        message.textColor = UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1)
        message.font = UIFont.systemFont(ofSize: 17)
        
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
    }
    
    func displayEvents(){
        eventView.removeAll()
        for todaysEvent in self.finalEventList{
            let event = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            let eventName = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            let eventTime = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            let eventPriority = UIView(frame: CGRect(x: 0, y:0, width:0, height: 0))
            
            let tapGesture = EventGestureRecognizer(target: self, action: #selector(displayDetail(_:)))
            tapGesture.eventView = event
            tapGesture.event = todaysEvent
            tapGesture.delegate = self
            event.addGestureRecognizer(tapGesture)
            
            eventName.text = todaysEvent.eventName
            eventName.textColor = .white
            eventName.font = UIFont.systemFont(ofSize: 25)
            
            eventTime.text = todaysEvent.startDate.toString(dateFormat: "HH:mm")+" - "+todaysEvent.endDate.toString(dateFormat: "HH:mm")
            eventTime.textColor = .white
            eventTime.font = UIFont.systemFont(ofSize: 15)
            
            let eventDuration = todaysEvent.endDate.timeIntervalSince(todaysEvent.startDate)
            
            event.backgroundColor = SelectColor.getColor(color: todaysEvent.profileColour)
            event.translatesAutoresizingMaskIntoConstraints = false
            eventName.translatesAutoresizingMaskIntoConstraints = false
            eventPriority.translatesAutoresizingMaskIntoConstraints = false
            eventTime.translatesAutoresizingMaskIntoConstraints = false
            
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
                if eventDuration < 1300{
                    event.heightAnchor.constraint(equalToConstant:30).isActive = true
                }
                else{
                    event.heightAnchor.constraint(equalToConstant: (finalEndTime - finalStartTime) * 62).isActive = true
                }
            }
            
            event.addSubview(eventPriority)
            event.addSubview(eventName)
            event.addSubview(eventTime)
            
            eventPriority.topAnchor.constraint(equalTo: event.topAnchor, constant: 0).isActive = true
            eventPriority.leadingAnchor.constraint(equalTo: event.leadingAnchor, constant: 0).isActive = true
            eventPriority.heightAnchor.constraint(equalTo: event.heightAnchor, multiplier: 1).isActive = true
            eventPriority.widthAnchor.constraint(equalToConstant: 10).isActive = true
            eventPriority.backgroundColor = PriorityColorSelector.getColor(priority: todaysEvent.priority)
            
            eventTime.bottomAnchor.constraint(equalTo: event.bottomAnchor, constant: -10).isActive = true
            eventTime.trailingAnchor.constraint(equalTo: event.trailingAnchor, constant: -10).isActive = true
            
            eventName.topAnchor.constraint(equalTo: event.topAnchor, constant: 10).isActive = true
            eventName.bottomAnchor.constraint(equalTo: eventTime.topAnchor, constant: 10).isActive = true
            eventName.leadingAnchor.constraint(equalTo: eventPriority.trailingAnchor, constant: 10).isActive = true
            eventName.trailingAnchor.constraint(equalTo: event.trailingAnchor, constant: -10).isActive = true
            
            if todaysEvent.endDate.timeIntervalSince(todaysEvent.startDate) > 0 {
                eventName.numberOfLines = Int((todaysEvent.endDate.timeIntervalSince(todaysEvent.startDate))/3600)
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
    
    @objc func displayDetail(_ sender:EventGestureRecognizer){
        if let viewController = getOwningViewController() as? MainViewController {
            let popoverContent = viewController.storyboard!.instantiateViewController(withIdentifier: "SearchPanelViewController") as! SearchPanelViewController
            popoverContent.modalPresentationStyle = .overCurrentContext
            popoverContent.modalTransitionStyle = .crossDissolve
            popoverContent.onDismiss = onSegDismiss
            viewController.present(popoverContent, animated: true, completion: nil)
            popoverContent.getEventDetails(event: sender.event)
        }
    }
    
    @objc func displayAllDayListOfDetail(_ sender:EventGestureRecognizer){
        if let viewController = getOwningViewController() as? MainViewController {
            let popoverContent = viewController.storyboard!.instantiateViewController(withIdentifier: "SearchPanelViewController") as! SearchPanelViewController
            popoverContent.modalPresentationStyle = .overCurrentContext
            popoverContent.modalTransitionStyle = .crossDissolve
            popoverContent.onDismiss = onSegDismiss
            viewController.present(popoverContent, animated: true, completion: nil)
            popoverContent.getEventDetails(events: sender.listOfAllDayEvents)
        }
    }
    
    @objc func displayTaskListOfDetail(_ sender:TaskGestureRecognizer){
        if let viewController = getOwningViewController() as? MainViewController {
            let popoverContent = viewController.storyboard!.instantiateViewController(withIdentifier: "SearchPanelViewController") as! SearchPanelViewController
            popoverContent.modalPresentationStyle = .overCurrentContext
            popoverContent.modalTransitionStyle = .crossDissolve
            popoverContent.onDismiss = onSegDismiss
            viewController.present(popoverContent, animated: true, completion: nil)
            popoverContent.getTaskDetails(tasks: sender.taskList)
        }
    }
    
    func onSegDismiss(_ object: Any?) {
        if let event = object as? Events {
            if let viewController = getOwningViewController() as? MainViewController {
                let popoverContent = viewController.storyboard!.instantiateViewController(withIdentifier: "AddEditViewController") as! AddEditViewController
                popoverContent.modalPresentationStyle = .overCurrentContext
                popoverContent.modalTransitionStyle = .crossDissolve
                popoverContent.onDismiss = onViewDismiss
                viewController.present(popoverContent, animated: true, completion: nil)
                popoverContent.eventEditDetails(event: event)
            }
        } else if let task = object as? Task {
            if let viewController = getOwningViewController() as? MainViewController {
                
                let popoverContent = viewController.storyboard!.instantiateViewController(withIdentifier: "AddEditViewController") as! AddEditViewController
                popoverContent.modalPresentationStyle = .overCurrentContext
                popoverContent.modalTransitionStyle = .crossDissolve
                viewController.present(popoverContent, animated: true, completion: nil)
                popoverContent.taskEditDetails(task: task)
                popoverContent.onDismiss = onViewDismiss
            }
        }
    }
    
    func onViewDismiss() {
        getDailyViewForDate(eventDate: activeDate)
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
    
    func getHighlightedDate(selectedDate : Date){
        dayOneButton.backgroundColor = UIColor.white
        dayTwoButton.backgroundColor = UIColor.white
        dayThreeButton.backgroundColor = UIColor.white
        dayFourButton.backgroundColor = UIColor.white
        dayFiveButton.backgroundColor = UIColor.white
        daySixButton.backgroundColor = UIColor.white
        daySevenButton.backgroundColor = UIColor.white
        
        var arrayOfButton = Array<UIButton>()
        
        dayOneButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        arrayOfButton.append(dayOneButton)
        dayTwoButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        arrayOfButton.append(dayTwoButton)
        dayThreeButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        arrayOfButton.append(dayThreeButton)
        dayFourButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        arrayOfButton.append(dayFourButton)
        dayFiveButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        arrayOfButton.append(dayFiveButton)
        daySixButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        arrayOfButton.append(daySixButton)
        daySevenButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        arrayOfButton.append(daySevenButton)
        
        for actionButton in arrayOfButton{
            if actionButton.titleLabel?.text == selectedDate.toString(dateFormat:"d E"){
                actionButton.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.96, alpha: 1.00)
                actionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            }
        }
    }
}
