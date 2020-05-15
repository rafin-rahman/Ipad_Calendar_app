//
//  WeekView.swift
//  Calendars
//
//  Created by Rafin Rahman on 12/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class WeekView: UIView, CalendarProtocol, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var dayZero: UILabel!
    @IBOutlet weak var dayOneButton: UIButton!
    @IBOutlet weak var dayTwoButton: UIButton!
    @IBOutlet weak var dayThreeButton: UIButton!
    @IBOutlet weak var dayFourButton: UIButton!
    @IBOutlet weak var dayFiveButton: UIButton!
    @IBOutlet weak var daySixButton: UIButton!
    @IBOutlet weak var daySevenButton: UIButton!
    
    @IBOutlet weak var weekLabel: UILabel!
    
    @IBOutlet weak var rightScroll: UIScrollView!
    @IBOutlet weak var leftScroll: UIScrollView!
    @IBOutlet weak var taskBarView: UIView!
    @IBOutlet weak var taskStackView: UIStackView!
    @IBOutlet weak var allDayStackView: UIStackView!
    @IBOutlet weak var tempStackView: UIStackView!
    
    
    var activeDate: Date = Date()
    
    var eventView : Array<UIView> = Array()
    var allDayListView : Array<UIView> = Array()
    var taskView:Array<UIView> = Array()
    
    var finalAllDayEventList: Array<Events> = Array()
    
    var savedGestureEvent : EventGestureRecognizer!
    var savedGestureTask : TaskGestureRecognizer!
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    func loadData() {
        getWeeklyView(date: Date())
    }
    
    func getWeeklyView(date:Date){
        getDates(date: date)
        activeDate = date
        getTask(date: activeDate)
        getAllDayTask(date: activeDate)
        getAllEvent(date: activeDate)
    }
    
    func getTask(date:Date){
        taskStackView.removeAllArrangedSubviews()
        let taskDAO = TaskDAO()
        taskDAO.getAllTasksFromDays(startDate: date.stripTime(), endDate: (Calendar.current.date(byAdding: .day, value: 8, to: date)?.stripTime())!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.displayAllTaskForDays(taskDict: self.sortTaskAccordingToDate(tasks: taskDAO.taskList))
        }
    }
    
    func sortTaskAccordingToDate(tasks:Array<Task>) -> Dictionary<Date, Array<Task>>{
        var taskDict : Dictionary <Date, Array<Task>> = Dictionary()
        var numberOfDays = 0
        while(numberOfDays != 7){
            taskDict[(Calendar.current.date(byAdding: .day, value: numberOfDays, to: activeDate)?.stripTime())!] = Array<Task>()
            numberOfDays += 1
        }
        
        for task in tasks{
            taskDict[task.taskDateAndTime.stripTime(), default: []].append(task)
        }
        return taskDict
    }
    
    func displayAllTaskForDays(taskDict:Dictionary<Date,Array<Task>>){
        let sortedDic = taskDict.sorted { (firstDic, secondDic) -> Bool in
            return firstDic.key < secondDic.key
        }
        
        for (_, listOfTask) in sortedDic{
            if savedGestureTask != nil {
                taskBarView.removeGestureRecognizer(savedGestureTask)
            }
            
            let taskView = TempConstraintView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            taskView.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "#8395a7", alpha: 1.0)
            taskStackView.addArrangedSubview(taskView)
            taskView.translatesAutoresizingMaskIntoConstraints = false
            taskView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            var counter = 0
            
            for task in listOfTask{
                if !task.completedStatus{
                    counter += 1
                }
            }
            
            let message = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            message.textColor = .white
            message.font = UIFont.systemFont(ofSize: 17)
            
            taskView.addSubview(message)
            
            message.translatesAutoresizingMaskIntoConstraints = false
            message.centerYAnchor.constraint(equalTo: taskView.centerYAnchor, constant: 0).isActive = true
            message.centerXAnchor.constraint(equalTo: taskView.centerXAnchor, constant: 0).isActive = true
            
            if listOfTask.count > 0 {
                let tapGesture = TaskGestureRecognizer(target: self, action: #selector(displayTaskListOfDetail(_:)))
                tapGesture.taskList = listOfTask
                tapGesture.delegate = self
                savedGestureTask = tapGesture
                taskView.addGestureRecognizer(tapGesture)
                
                message.text = String(counter) + " of " + String(listOfTask.count)
            }
            else{
                message.text = " -- "
            }
        }
    }
    
    @objc func displayTaskListOfDetail(_ sender:TaskGestureRecognizer){
        if let viewController = getOwningViewController() as? MainViewController {
            let popoverContent = viewController.storyboard!.instantiateViewController(withIdentifier: "SearchPanelViewController") as! SearchPanelViewController
            popoverContent.modalPresentationStyle = .overCurrentContext
            popoverContent.modalTransitionStyle = .crossDissolve
            popoverContent.onDismiss = onSegDismiss
            viewController.present(popoverContent, animated: true, completion: nil)
            popoverContent.getTaskDetails(tasks: sender.taskList, activeDate: dayZero.text?.toDate(dateFormat: "dd-MM-yy") ?? Date())
        }
    }
    
    func getAllDayTask(date:Date){
        allDayStackView.removeAllArrangedSubviews()
        let eventDAO = EventDAO()
        eventDAO.getEvents(eventStartDate: date.stripTime(), eventEndDate: (Calendar.current.date(byAdding: .day, value: 8, to: date)?.stripTime())!, allDayStatus: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.finalAllDayEventList = eventDAO.getEventFromDays()
            self.displayAllDayEventsForDays(eventDic: self.sortEventAccordingToDate(events: self.finalAllDayEventList))
        }
    }
    
    func sortEventAccordingToDate(events:Array<Events>) -> Dictionary<Date, Array<Events>>{
        var eventDic : Dictionary <Date, Array<Events>> = Dictionary()
        var numberOfDays = 0
        while(numberOfDays != 7){
            eventDic[(Calendar.current.date(byAdding: .day, value: numberOfDays, to: activeDate)?.stripTime())!] = Array<Events>()
            numberOfDays += 1
        }
        
        for event in events{
            event.activeDate = activeDate
            eventDic[event.startDate.stripTime(), default: []].append(event)
        }
        return eventDic
    }
    
    func displayAllDayEventsForDays(eventDic:Dictionary<Date,Array<Events>>){
        let sortedDic = eventDic.sorted { (firstDic, secondDic) -> Bool in
            return firstDic.key < secondDic.key
        }
        
        for (_, listOfEvents) in sortedDic{
            if savedGestureEvent != nil {
                allDayStackView.removeGestureRecognizer(savedGestureEvent)
            }
            
            let eventView = TempConstraintView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            eventView.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "596275", alpha: 1.0)
            
            allDayStackView.addArrangedSubview(eventView)
            eventView.translatesAutoresizingMaskIntoConstraints = false
            eventView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            let message = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            message.textColor = .white
            message.font = UIFont.systemFont(ofSize: 17)
            
            eventView.addSubview(message)
            
            message.translatesAutoresizingMaskIntoConstraints = false
            
            message.centerYAnchor.constraint(equalTo: eventView.centerYAnchor, constant: 0).isActive = true
            message.centerXAnchor.constraint(equalTo: eventView.centerXAnchor, constant: 0).isActive = true
            
            if listOfEvents.count > 0 {
                let tapGesture = EventGestureRecognizer(target: self, action: #selector(displayAllDayListOfDetail(_:)))
                tapGesture.listOfAllDayEvents = listOfEvents
                tapGesture.delegate = self
                savedGestureEvent = tapGesture
                eventView.addGestureRecognizer(tapGesture)
                message.text = String(listOfEvents.count) + " Event/s"
            }
            else{
                message.text = " -- "
            }
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
    
    func clearAllEvents(){
        for subview in self.eventView {
            subview.removeFromSuperview()
        }
    }
    
    func getAllEvent(date:Date){
        clearAllEvents()
        let eventDAO = EventDAO()
        eventDAO.getEvents(eventStartDate: date.stripTime(), eventEndDate: (Calendar.current.date(byAdding: .day, value: 8, to: date)?.stripTime())!, allDayStatus: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.finalAllDayEventList = eventDAO.getEventFromDays()
            self.displayEventsForDays(eventDic: self.sortEventAccordingToDate(events: self.finalAllDayEventList))
        }
    }
    
    func displayEventsForDays(eventDic:Dictionary<Date,Array<Events>>){
        let sortedDic = eventDic.sorted { (firstDic, secondDic) -> Bool in
            return firstDic.key < secondDic.key
        }
        
        var counter = 0
        
        for(_, listOfEvents) in sortedDic{
            for todaysEvent in listOfEvents{
                let event = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                let eventName = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
                let eventTime = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
                let eventPriority = UIView(frame: CGRect(x: 0, y:0, width:0, height: 0))
                
                let tapGesture = EventGestureRecognizer(target: self, action: #selector(displayDetails(_:)))
                tapGesture.eventView = event
                tapGesture.event = todaysEvent
                tapGesture.delegate = self
                event.addGestureRecognizer(tapGesture)
                
                eventName.text = todaysEvent.eventName
                eventName.textColor = .white
                eventName.font = UIFont.systemFont(ofSize: 13)
                eventName.contentMode = .top
                eventName.numberOfLines = 0
                eventName.sizeToFit()
                
                
                eventTime.text = todaysEvent.startDate.toString(dateFormat: "HH:mm")+" - "+todaysEvent.endDate.toString(dateFormat: "HH:mm")
                eventTime.textColor = .white
                eventTime.font = UIFont.systemFont(ofSize: 10)
                eventTime.adjustsFontSizeToFitWidth = true
                
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
                
                
                event.topAnchor.constraint(equalTo: self.rightScroll.topAnchor, constant: finalStartTime * 62).isActive = true
                event.leadingAnchor.constraint(equalTo: rightScroll.leadingAnchor, constant: (rightScroll.layer.bounds.width/7) * CGFloat(counter)).isActive = true
                event.widthAnchor.constraint(equalTo: tempStackView.widthAnchor, multiplier: 1).isActive = true
                
                if eventDuration < 1300{
                    event.heightAnchor.constraint(equalToConstant:30).isActive = true
                }
                else{
                    event.heightAnchor.constraint(equalToConstant: (finalEndTime - finalStartTime) * 62).isActive = true
                }
                               
                event.addSubview(eventPriority)
                event.addSubview(eventName)
                event.addSubview(eventTime)
                
                eventPriority.topAnchor.constraint(equalTo: event.topAnchor, constant: 0).isActive = true
                eventPriority.leadingAnchor.constraint(equalTo: event.leadingAnchor, constant: 0).isActive = true
                eventPriority.heightAnchor.constraint(equalTo: event.heightAnchor, multiplier: 1).isActive = true
                eventPriority.widthAnchor.constraint(equalToConstant: 10).isActive = true
                eventPriority.backgroundColor = PriorityColorSelector.getColor(priority: todaysEvent.priority)
                
                eventTime.bottomAnchor.constraint(equalTo: event.bottomAnchor, constant: -4).isActive = true
                eventTime.leadingAnchor.constraint(equalTo: eventPriority.trailingAnchor, constant: 5).isActive = true
                eventTime.trailingAnchor.constraint(equalTo: event.trailingAnchor, constant: -10).isActive = true
                
                eventName.topAnchor.constraint(equalTo: event.topAnchor, constant: 3).isActive = true
                eventName.bottomAnchor.constraint(equalTo: event.bottomAnchor, constant: -20).isActive = true
                eventName.leadingAnchor.constraint(equalTo: eventPriority.trailingAnchor, constant: 10).isActive = true
                eventName.trailingAnchor.constraint(equalTo: event.trailingAnchor, constant: -10).isActive = true
               
            }
            counter += 1
        }
    }
    
    @objc func displayDetails(_ sender:EventGestureRecognizer)
    {
        if let viewController = getOwningViewController() as? MainViewController {
            let popoverContent = viewController.storyboard!.instantiateViewController(withIdentifier: "SearchPanelViewController") as! SearchPanelViewController
            popoverContent.modalPresentationStyle = .overCurrentContext
            popoverContent.modalTransitionStyle = .crossDissolve
            popoverContent.onDismiss = onSegDismiss
            viewController.present(popoverContent, animated: true, completion: nil)
            popoverContent.getEventDetails(event: sender.event)
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
        getWeeklyView(date: activeDate)
    }
    
    // Syncronize scroll views position
    func synchronizeScrollViewY(_ scrollViewToScroll: UIScrollView, toScrollView scrolledView: UIScrollView){
        var yPosition = scrollViewToScroll.contentOffset
        yPosition.y = scrolledView.contentOffset.y
        scrollViewToScroll.setContentOffset(yPosition, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == rightScroll{
            self.synchronizeScrollViewY(leftScroll, toScrollView: rightScroll)
        }
            
        else if scrollView == leftScroll{
            self.synchronizeScrollViewY(rightScroll, toScrollView: leftScroll)
        }
    }
    
    @IBAction func previousButtonClick(_ sender: UIButton) {
        let date = dayZero.text!.toDate(dateFormat: "dd-MM-yy")!
        getDates(date: Calendar.current.date(byAdding: .day, value: -7, to: date)!)
        getTask(date: activeDate)
        getAllDayTask(date: activeDate)
        getAllEvent(date: activeDate)
    }
    
    @IBAction func nextButtonClick(_ sender: UIButton) {
        let date = dayZero.text!.toDate(dateFormat: "dd-MM-yy")!
        getDates(date: Calendar.current.date(byAdding: .day, value: 7, to: date)!)
        getTask(date: activeDate)
        getAllDayTask(date: activeDate)
        getAllEvent(date: activeDate)
    }
    
    func getDates(date:Date){
        let newFormat = DateFormatter()
        newFormat.dateFormat = "dd-MM-yy"
        
        let format = DateFormatter()
        format.dateFormat = "d E"
        
        weekLabel.text = "Week "+String(Calendar.current.component(.weekOfMonth, from: date)) + "\n" + date.toString(dateFormat: "MMM")
        weekLabel.adjustsFontSizeToFitWidth = true
        weekLabel.numberOfLines = 2
        
        dayZero.text = newFormat.string(from: Calendar.current.date(byAdding: .day, value: 0, to: date)!)
        
        activeDate = Calendar.current.date(byAdding: .day, value: 0, to: date)!
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
    
    @IBAction func dayButtonClick(_ sender: UIButton) {
        if let homeView = self.superview as? HomeView{
            let newFormat = DateFormatter()
            newFormat.dateFormat = "dd-MM-yy"
            let selectedDate = dayZero.text!
            let convertedToDate = Calendar.current.date(byAdding: .day, value: sender.tag, to: newFormat.date(from: selectedDate)!)!
            homeView.getDayView(date: convertedToDate)
        }
    }
    
}


