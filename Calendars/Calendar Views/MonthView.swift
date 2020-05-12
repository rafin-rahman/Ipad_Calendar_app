//
//  MonthVIew.swift
//  Calendars
//
//  Created by Rafin Rahman on 12/04/2020.
//  Copyright © 2020 Rafin R
//

import UIKit

class MonthView: UIView, CalendarProtocol, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var activeDate = Date()
    var numberOfDays : Int = 0
    
    var counter : Int = 0
    var detailsDict: Dictionary<Date,Array<Int>> = Dictionary()
    
    func loadData() {
        getDataForMonth(activeDate: Date())
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    func getDataForMonth(activeDate:Date){
        let eventDAO = EventDAO()
        let taskDAO = TaskDAO()
        
        self.activeDate = activeDate
        
        eventDAO.getEvents(eventStartDate: activeDate.startOfMonth, eventEndDate: activeDate.endOfMonth)
        taskDAO.getAllTasksFromDays(startDate: activeDate.startOfMonth, endDate: activeDate.endOfMonth)
        
        numberOfDays = Int(activeDate.endOfMonth.timeIntervalSince(activeDate.startOfMonth)/86400 + 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let eventDic = self.sortEventAccordingToDate(events: eventDAO.getEventFromDays(), numberOfDays: self.numberOfDays)
            let taskDic = self.sortTaskAccordingToDate(tasks: taskDAO.taskList, numberOfDays: self.numberOfDays)
            self.getCountOfEventsAndTasks(eventDic: eventDic, taskDic: taskDic)
        }
        
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
        print(detailsDict)
        registerData()
        collectionView.reloadData()
        
    }
    
    func registerData() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout = layout
        
        let nib = UINib(nibName: "MonthCellView", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MonthCellView")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func sortEventAccordingToDate(events:Array<Events>, numberOfDays:Int) -> Dictionary<Date, Array<Events>>{
        var eventDic : Dictionary <Date, Array<Events>> = Dictionary()
        var counter = 0
        while(counter != numberOfDays){
            eventDic[(Calendar.current.date(byAdding: .day, value: counter, to: activeDate.startOfMonth)?.stripTime())!] = Array<Events>()
            counter += 1
        }
                
        for event in events{
            event.activeDate = activeDate
            eventDic[event.startDate.stripTime(), default: []].append(event)
        }
        return eventDic
    }
    
    func sortTaskAccordingToDate(tasks:Array<Task>, numberOfDays:Int) -> Dictionary<Date, Array<Task>>{
        var taskDict : Dictionary <Date, Array<Task>> = Dictionary()
        var counter = 0
        while(counter != numberOfDays){
            taskDict[(Calendar.current.date(byAdding: .day, value: counter, to: activeDate.startOfMonth)?.stripTime())!] = Array<Task>()
            counter += 1
        }
        
        for task in tasks{
            taskDict[task.taskDateAndTime.stripTime(), default: []].append(task)
        }
        return taskDict
    }
    
    
    let spacing:CGFloat = 1
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        counter = 0
        return (activeDate.startOfMonth.dayNumberOfWeek()! - 1) + numberOfDays + (7 - activeDate.endOfMonth.dayNumberOfWeek()!)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCellView", for: indexPath) as? MonthCellView else {
            fatalError("can't dequeue CustomCell")
        }
        
       
        
        if indexPath.item < (activeDate.startOfMonth.dayNumberOfWeek()! - 1) && counter < 1{
            cell.clearDate()
        }
        
        if indexPath.item == (activeDate.startOfMonth.dayNumberOfWeek()! - 1) && counter == 0{
             counter += 1
        }
        print(numberOfDays)
        if counter > 0 && counter <= numberOfDays{
            let date = Calendar.current.date(byAdding: .day, value: counter - 1, to: activeDate.startOfMonth)
            print("date", date)
            let eventNumber = detailsDict[date!]!
            cell.populateData(dayNumber: counter, eventNumber: eventNumber[0], taskNumber: eventNumber[1])
            counter += 1
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(onCellClick(_:)))
            gesture.delegate = self
            cell.addGestureRecognizer(gesture)
        }
        else {
            cell.clearDate()
            
        }
        
        cell.layer.cornerRadius = 0
        cell.layer.borderWidth = 0
        cell.layer.borderColor = HexToUIColor.hexStringToUIColor(hex: "273C75", alpha: 1).cgColor
        return cell
    }
    
    @objc func onCellClick(_ sender:UITapGestureRecognizer){
        print("Click")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 7.1
        let numberOfRows:CGFloat = 5.1
        
        if let collection = self.collectionView{
            let width = collection.bounds.width/numberOfItemsPerRow
            let height = collection.bounds.height/numberOfRows
            return CGSize(width: width, height: height)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }

    @IBAction func nextButtonClick(_ sender: UIButton) {
        let currentYear = yearLabel.text!.toDate(dateFormat: "yyyy")!
        yearLabel.text = Calendar.current.date(byAdding: .year, value: 1, to: currentYear)?.toString(dateFormat: "yyyy")
    }
    
    @IBAction func previousButtonClick(_ sender: UIButton) {
//        let currentYear = yearLabel.text!.toDate(dateFormat: "yyyy")!
//        yearLabel.text = Calendar.current.date(byAdding: .year, value: -1, to: currentYear)?.toString(dateFormat: "yyyy")
        
        getDataForMonth(activeDate: "01-06-2020".toDate(dateFormat: "dd-MM-yyyy"))
    }
    
    
}
