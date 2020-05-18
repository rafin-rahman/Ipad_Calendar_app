//
//  YearMonthView.swift
//  Calendars
//
//  Created by Rafin Rahman on 11/05/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class MonthDisplayView: UIView, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var rowOne: UIStackView!
    @IBOutlet weak var rowTwo: UIStackView!
    @IBOutlet weak var rowThree: UIStackView!
    @IBOutlet weak var rowFour: UIStackView!
    @IBOutlet weak var rowFive: UIStackView!
    @IBOutlet weak var rowSix: UIStackView!
    
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    
    var arrayOfMonth = Array<Int>()
    var detailsDict : Dictionary<Date, Array<Int>>!
    
    var activeMonth = Date()
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    func onLoad(activeMonth:Date)
    {
        clearAllStack()
        setLabelForMonth()
        self.activeMonth = activeMonth
        let numberOfDays = Int(activeMonth.endOfMonth.timeIntervalSince(activeMonth.startOfMonth)/86400 + 1)
        loadArray(date: activeMonth, numberOfDays: numberOfDays)
        
        let eventDAO = EventDAO()
        let taskDAO = TaskDAO()
        
        eventDAO.getEvents(eventStartDate: activeMonth.startOfMonth, eventEndDate: activeMonth.endOfMonth)
        taskDAO.getAllTasksFromDays(startDate: activeMonth.startOfMonth, endDate: activeMonth.endOfMonth)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let eventDic = self.sortEventAccordingToDate(events: eventDAO.getEventFromDays(), numberOfDays: numberOfDays)
            let taskDic = self.sortTaskAccordingToDate(tasks: taskDAO.taskList, numberOfDays: numberOfDays)
            self.getCountOfEventsAndTasks(eventDic: eventDic, taskDic: taskDic)
            self.loadData()
        }
        
    }
    
    func loadArray(date:Date, numberOfDays:Int){
        var number = numberOfDays
        let startingWeek = date.startOfMonth.dayNumberOfWeek()! - 1
        if startingWeek > 0 {
            for _ in 1...startingWeek{
                arrayOfMonth.append(0)
            }
        }
        
        if number > 31{
            number = 31
        }
        
        for i in 1...number{
            arrayOfMonth.append(i)
        }
        
        let numberInEnd = 7 - date.endOfMonth.dayNumberOfWeek()!
        if numberInEnd > 0{
            for _ in 1...numberInEnd{
                arrayOfMonth.append(0)
            }
        }
    }
    
    func loadData(){
        for element in arrayOfMonth{
            let monthCellView = UINib(nibName: "MonthCellView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? MonthCellView
            monthCellView!.translatesAutoresizingMaskIntoConstraints = false
            
            if arrayOfMonth.count > 35{
                monthCellView!.heightAnchor.constraint(equalToConstant: superview!.frame.height / 6 ).isActive = true
            }
            else{
                 monthCellView!.heightAnchor.constraint(equalToConstant: superview!.frame.height / 5 ).isActive = true
            }
           
            
            if element == 0{
                monthCellView?.clearDate()
            }
            else{
                let date = Calendar.current.date(byAdding: .day, value: element-1, to: activeMonth.startOfMonth)
                let eventNumber = detailsDict[date!]!
                monthCellView!.populateData(dayNumber: element, eventNumber: eventNumber[0], taskNumber: eventNumber[1])
                
                let singleTap = DayTapGesture(target: self, action: #selector(onTapDay(_:)))
                singleTap.delegate = self
                singleTap.date = date
                monthCellView!.addGestureRecognizer(singleTap)
            }
            
            
            if rowOne.subviews.count < 7{
                rowOne.addArrangedSubview(monthCellView!)
            }
            else if rowTwo.subviews.count < 7{
                rowTwo.addArrangedSubview(monthCellView!)
            }
            else if rowThree.subviews.count < 7{
                rowThree.addArrangedSubview(monthCellView!)
            }
            else if rowFour.subviews.count < 7{
                rowFour.addArrangedSubview(monthCellView!)
            }
            else if rowFive.subviews.count < 7{
                rowFive.addArrangedSubview(monthCellView!)
            }
            else {
                rowSix.addArrangedSubview(monthCellView!)
            }
            
        }
    }
    
    @objc func onTapDay(_ sender: DayTapGesture){
        if let homeView = self.superview?.superview as? HomeView{
            homeView.getDayView(date: sender.date)
        }
    }
    
    func setLabelForMonth(){
        sundayLabel.text = "Sun"
        mondayLabel.text = "Mon"
        tuesdayLabel.text = "Tue"
        wednesdayLabel.text = "Wed"
        thursdayLabel.text = "Thr"
        fridayLabel.text = "Fri"
        saturdayLabel.text = "Sat"
    }
    
    func clearAllStack(){
        rowOne.removeAllArrangedSubviews()
        rowTwo.removeAllArrangedSubviews()
        rowThree.removeAllArrangedSubviews()
        rowFour.removeAllArrangedSubviews()
        rowFive.removeAllArrangedSubviews()
        rowSix.removeAllArrangedSubviews()
    }
    
    
    func getCountOfEventsAndTasks(eventDic:Dictionary<Date, Array<Events>>, taskDic:Dictionary<Date, Array<Task>>){
        detailsDict = Dictionary<Date, Array<Int>>()
        let sortedDicEvent = eventDic.sorted { (firstDic, secondDic) -> Bool in
            return firstDic.key < secondDic.key
        }
        
        for (date,events) in sortedDicEvent{
            detailsDict[date, default: []].append(events.count)
        }
        
        let sortedDicTask = taskDic.sorted { (firstDic, secondDic) -> Bool in
            return firstDic.key < secondDic.key
        }
        
        for (date,tasks) in sortedDicTask{
            detailsDict[date, default: []].append(tasks.count)
        }
        
        
    }
    
    func sortEventAccordingToDate(events:Array<Events>, numberOfDays:Int) -> Dictionary<Date, Array<Events>>{
        var eventDic : Dictionary <Date, Array<Events>> = Dictionary()
        var counter = 0
        while(counter != numberOfDays){
            eventDic[(Calendar.current.date(byAdding: .day, value: counter, to: activeMonth.startOfMonth)?.stripTime())!] = Array<Events>()
            counter += 1
        }
        
        for event in events{
            event.activeDate = activeMonth
            eventDic[event.startDate.stripTime(), default: []].append(event)
        }
        return eventDic
    }
    
    func sortTaskAccordingToDate(tasks:Array<Task>, numberOfDays:Int) -> Dictionary<Date, Array<Task>>{
        var taskDict : Dictionary <Date, Array<Task>> = Dictionary()
        var counter = 0
        while(counter != numberOfDays){
            taskDict[(Calendar.current.date(byAdding: .day, value: counter, to: activeMonth.startOfMonth)?.stripTime())!] = Array<Task>()
            counter += 1
        }
        for task in tasks{
            taskDict[task.taskDateAndTime.stripTime(), default: []].append(task)
        }
        return taskDict
    }
    
}
