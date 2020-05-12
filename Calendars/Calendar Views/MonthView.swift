//
//  MonthVIew.swift
//  Calendars
//
//  Created by Rafin Rahman on 12/04/2020.
//  Copyright © 2020 Rafin R
//

import UIKit

enum StateOfCollectionView{
    case before
    case content
    case after
}

class MonthView: UIView, CalendarProtocol, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var janButton: UIButton!
    @IBOutlet weak var febButton: UIButton!
    @IBOutlet weak var marButton: UIButton!
    @IBOutlet weak var aprButton: UIButton!
    @IBOutlet weak var mayButton: UIButton!
    @IBOutlet weak var junButton: UIButton!
    @IBOutlet weak var julButton: UIButton!
    @IBOutlet weak var augButton: UIButton!
    @IBOutlet weak var sepButton: UIButton!
    @IBOutlet weak var octButton: UIButton!
    @IBOutlet weak var novButton: UIButton!
    @IBOutlet weak var decButton: UIButton!
    
    @IBOutlet weak var monthView: UIView!
        
    var activeDate = Date()
    var numberOfDays : Int = 0
    
    var counter : Int = 0
    var currentState: StateOfCollectionView = .before
    var detailsDict: Dictionary<Date,Array<Int>> = Dictionary()
    
    func loadData() {
        if let monthDisplay = UINib(nibName: "YearMonthView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            YearMonthView{
            setMonthView(newView: monthDisplay)
            getDataForMonth(activeDate: "10-06-2020".toDate(dateFormat: "dd-MM-yyyy"))
        }
        
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
    
    
    @IBAction func nextButtonClick(_ sender: UIButton) {
        let currentYear = yearLabel.text!.toDate(dateFormat: "yyyy")!
        yearLabel.text = Calendar.current.date(byAdding: .year, value: 1, to: currentYear)?.toString(dateFormat: "yyyy")
    }
    
    @IBAction func previousButtonClick(_ sender: UIButton) {
        let currentYear = yearLabel.text!.toDate(dateFormat: "yyyy")!
        yearLabel.text = Calendar.current.date(byAdding: .year, value: -1, to: currentYear)?.toString(dateFormat: "yyyy")
    }
    
    @IBAction func monthButtonClick(_ sender: UIButton) {
        let month = sender.tag
        
        janButton.backgroundColor = UIColor.white
        febButton.backgroundColor = UIColor.white
        marButton.backgroundColor = UIColor.white
        aprButton.backgroundColor = UIColor.white
        mayButton.backgroundColor = UIColor.white
        junButton.backgroundColor = UIColor.white
        julButton.backgroundColor = UIColor.white
        augButton.backgroundColor = UIColor.white
        sepButton.backgroundColor = UIColor.white
        octButton.backgroundColor = UIColor.white
        novButton.backgroundColor = UIColor.white
        decButton.backgroundColor = UIColor.white
        
        janButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        febButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        marButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        aprButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        mayButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        junButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        julButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        augButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        sepButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        octButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        novButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        decButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        
        sender.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.96, alpha: 1.00)
        sender.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)

        let selectedDate = "01-" + String(month) + "-" + yearLabel.text!
        getDataForMonth(activeDate: selectedDate.toDate(dateFormat: "dd-MM-yyyy"))
    }
    
    func setMonthView(newView: UIView){
        if monthView != nil {
            monthView.removeFromSuperview()
        }
        monthView = newView
        monthView.translatesAutoresizingMaskIntoConstraints = false
        monthView.frame = CGRect(x: 0, y: 0, width: monthView.frame.width, height: monthView.frame.height)
        self.addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: janButton.bottomAnchor).isActive = true
        monthView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        monthView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        monthView.bottomAnchor.constraint(equalTo: ).isActive = true
        
    }
    
//    func registerData() {
//
//           let layout = UICollectionViewFlowLayout()
//           layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
//           layout.minimumLineSpacing = spacing
//           layout.minimumInteritemSpacing = spacing
//           self.collectionView.collectionViewLayout = layout
//
//           let nib = UINib(nibName: "MonthCellView", bundle: nil)
//           collectionView.register(nib, forCellWithReuseIdentifier: "MonthCellView")
//           collectionView.dataSource = self
//           collectionView.delegate = self
//       }
//
//    let spacing:CGFloat = 1
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        counter =  activeDate.startOfMonth.dayNumberOfWeek()! - 1
//        return (activeDate.startOfMonth.dayNumberOfWeek()! - 1) + numberOfDays + (7 - activeDate.endOfMonth.dayNumberOfWeek()!)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCellView", for: indexPath) as? MonthCellView else {
//            fatalError("can't dequeue CustomCell")
//        }
//
//        switch currentState {
//        case .before:
//            cell.clearDate()
//            counter -= 1
//            if counter == 0 {
//                currentState = .content
//            }
//        case .content:
//            let date = Calendar.current.date(byAdding: .day, value: counter, to: activeDate.startOfMonth)
//            let eventNumber = detailsDict[date!]!
//            cell.populateData(dayNumber: counter + 1, eventNumber: eventNumber[0], taskNumber: eventNumber[1])
//
//            let gesture = UITapGestureRecognizer(target: self, action: #selector(onCellClick(_:)))
//            gesture.delegate = self
//            cell.addGestureRecognizer(gesture)
//            counter += 1
//            if counter == numberOfDays {
//                currentState = .after
//                counter = 7 - activeDate.endOfMonth.dayNumberOfWeek()!
//            }
//        case .after:
//            cell.clearDate()
//            counter -= 1
//        }
//
//        cell.isHidden = false
//
//        cell.layer.cornerRadius = 0
//        cell.layer.borderWidth = 0
//        cell.layer.borderColor = HexToUIColor.hexStringToUIColor(hex: "273C75", alpha: 1).cgColor
//        return cell
//    }
//
//    @objc func onCellClick(_ sender:UITapGestureRecognizer){
//        print("Click")
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let numberOfItemsPerRow:CGFloat = 7.1
//        let numberOfRows:CGFloat = 5.2
//
//        if let collection = self.collectionView{
//            let width = collection.bounds.width/numberOfItemsPerRow
//            let height = collection.bounds.height/numberOfRows
//            return CGSize(width: width, height: height)
//        }else{
//            return CGSize(width: 0, height: 0)
//        }
//    }

    
}
