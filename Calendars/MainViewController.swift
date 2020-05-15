//
//  ViewController.swift
//  Calendars
//
//  Created by Rafin Rahman on 21/03/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

struct Notification {
    struct Category {
        static let taskSuggestion = "taskSuggestion"
    }
    
    struct Action {
        static let addTask = "addTask"
    }
}

class MainViewController: UIViewController, UNUserNotificationCenterDelegate{
    
    @IBOutlet weak var searchText: UITextField!
    // nagivation buttons
    @IBOutlet weak var homeNavButton: UIButton!
    @IBOutlet weak var eventNavButton: UIButton!
    @IBOutlet weak var taskNavButton: UIButton!
    @IBOutlet weak var binNavButton: UIButton!
    @IBOutlet weak var profileNavButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    
    // nagivation labels
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var binLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    
    
    // add, edit, task button constraint
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var eventButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var eventButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var eventButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var eventButtonBottom: NSLayoutConstraint!
    
    @IBOutlet weak var taskButton: UIButton!
    @IBOutlet weak var taskButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var taskButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var taskButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var taskButtonBottom: NSLayoutConstraint!
    
    var rightView: NavigationProtocol!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var searchViewTop: UIView!
    
    @IBOutlet weak var sidebarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightViewTrailingToSafeArea: NSLayoutConstraint!
    
    var addButtonStatus = false;
    var timer : Timer!
    var deleteTimer : Timer!
    var suggestionTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onHomeClick(nil)
        addButtonStyle()
        
        let singleTapSelector = #selector(self.onSingleTap)
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: singleTapSelector)
        view.addGestureRecognizer(singleTap)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(notificationForEventsAndTasks), userInfo: nil, repeats: true)
        deleteTimer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(deleteFromBin), userInfo: nil, repeats: true)
        suggestionTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(showSuggestedTask), userInfo: nil, repeats: true)
    }
    
    @objc func deleteFromBin(){
        let eventDAO = EventDAO()
        let taskDAO = TaskDAO()
        eventDAO.getAllDeletedEventsFromDate(date: Calendar.current.date(byAdding: .day, value: -30, to: Date().stripTime())!)
        taskDAO.getAllDeletedTask(deleteTime: Calendar.current.date(byAdding: .day, value: -30, to: Date().stripTime())!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            for event in eventDAO.eventList{
                eventDAO.deleteEvent(eventId: event.id)
            }
            for task in taskDAO.taskList{
                taskDAO.deleteTask(taskId: task.id)
            }
        }
    }
    
    @objc func showSuggestedTask(){
        var taskSuggestionList = Array<Task>()
        let taskDaoForPreviousTask = TaskDAO()
        let taskDaoForCurrentTask = TaskDAO()
        
        taskDaoForPreviousTask.getAllTasksBeforeToday()
        taskDaoForCurrentTask.getAllTasksFromDays(startDate: Date().stripTime(), endDate: Calendar.current.date(byAdding: .day, value: 1, to: Date().stripTime())!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            for taskFirst in taskDaoForPreviousTask.taskList{
                var counter = 0
                for task in taskDaoForPreviousTask.taskList{
                    if taskFirst.taskName == task.taskName && taskFirst.taskDateAndTime.toString(dateFormat: "hh:mm") == task.taskDateAndTime.toString(dateFormat: "hh:mm"){
                        counter += 1
                        if counter == 5 {
                            if taskSuggestionList.count > 0{
                                for taskAdd in taskSuggestionList{
                                    if taskAdd.taskName != task.taskName{
                                        taskSuggestionList.append(task)
                                    }
                                }
                            }
                            else{
                                taskSuggestionList.append(task)
                            }
                        }
                    }
                }
            }
            
            for suggestedTask in taskSuggestionList{
                var status = false
                for task in taskDaoForCurrentTask.taskList{
                    if task.taskName != suggestedTask.taskName{
                        status = true
                    }
                }
                
                if status || taskDaoForCurrentTask.taskList.count == 0{
                    self.showNotification(suggestedTask: suggestedTask)
                }
            }
        }
    }
    
    func showOptionForNotification(){
        let centre = UNUserNotificationCenter.current()
        centre.delegate = self
        
        let actionAddTask = UNNotificationAction(identifier: Notification.Action.addTask, title: "Add Task", options: [])
        
        let category = UNNotificationCategory(identifier: Notification.Category.taskSuggestion, actions: [actionAddTask], intentIdentifiers: [], options: [])
        centre.setNotificationCategories([category])
    }
    
    func showNotification(suggestedTask:Task){
        showOptionForNotification()
        
        let centre = UNUserNotificationCenter.current()
        centre.removeAllPendingNotificationRequests()
        let content = UNMutableNotificationContent()
        
        content.title = "Task"
        content.subtitle = "Suggested Task"
        content.body = suggestedTask.taskName + " at " + suggestedTask.taskDateAndTime.toString(dateFormat: "HH:mm")
        
        let date = Date().toString(dateFormat: "dd-MM-yyyy") + " " + suggestedTask.taskDateAndTime.toString(dateFormat: "HH:mm")
        
        content.userInfo = [
            "Name" : suggestedTask.taskName,
            "DateAndTime" : date.toDate(dateFormat: "dd-MM-yyyy HH:mm")!,
            "ReminderTime" : suggestedTask.reminder,
            "Priority" : suggestedTask.priority,
            "Profile" : suggestedTask.profile,
            "ProfileColour" : suggestedTask.profileColour,
            "CompletedStatus": false,
            "DeleteStatus" : false,
            "DeleteTime" : Date()
        ]
        content.categoryIdentifier = Notification.Category.taskSuggestion
        content.sound = UNNotificationSound.default
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute],from: suggestedTask.taskDateAndTime.stripDate())
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        centre.add(request) {(error) in
            if error != nil{
                print(error!)
            }}
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let taskDetails = response.notification.request.content.userInfo
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            print("Default Action")
        case Notification.Action.addTask:
            print("Checking")
            let taskDic : Dictionary<String, Any> = [
                "Name" : taskDetails["Name"] as! String,
                "DateAndTime" : taskDetails["DateAndTime"] as! Date,
                "ReminderTime" : taskDetails["ReminderTime"] as! Date,
                "Priority" : taskDetails["Priority"] as! String,
                "Profile" : taskDetails["Profile"] as! String,
                "ProfileColour" : taskDetails["ProfileColour"] as! String,
                "CompletedStatus": false,
                "DeleteStatus" : false,
                "DeleteTime" : Date()
            ]
            TaskDAO().addNewTask(taskDic: taskDic)
        default:
            print("Error")
        }
        
        completionHandler()
    }
    
    @objc func notificationForEventsAndTasks(){
        let eventDAO = EventDAO()
        let taskDAO = TaskDAO()
        eventDAO.getAllEventsForCurrentDay()
        taskDAO.getAllTasksFromDays(startDate: Date().stripTime(), endDate: Calendar.current.date(byAdding: .day, value: 1, to: Date().stripTime())!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            for event in eventDAO.eventList{
                let centre = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                
                content.title = "Event"
                content.subtitle = event.startDate.timeIntervalSince(event.reminder).stringFromTimeInterval() + " remaining"
                content.body = event.eventName
                content.sound = UNNotificationSound.default
                
                let dateComponents = Calendar.current.dateComponents([.year , .month, .day, .hour, .minute, .second],from: event.reminder)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let request = UNNotificationRequest(identifier: event.id, content: content, trigger: trigger)
                
                centre.add(request) {(error) in
                    if error != nil{
                        print(error!)
                    }}
            }
            
            for task in taskDAO.taskList{
                let centre = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                
                content.title = "Task"
                content.subtitle = task.taskDateAndTime.timeIntervalSince(task.reminder).stringFromTimeInterval() + " remaining"
                content.body = task.taskName
                content.sound = UNNotificationSound.default
                
                let dateComponents = Calendar.current.dateComponents([.year , .month, .day, .hour, .minute, .second],from: task.reminder)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let request = UNNotificationRequest(identifier: task.id, content: content, trigger: trigger)
                
                centre.add(request) {(error) in
                    if error != nil{
                        print(error!)
                    }}
            }
        }
    }
    
    
    @objc func onSingleTap(){
        view.endEditing(true)
    }
    
    @IBAction func showSidebar(_ sender: UIScreenEdgePanGestureRecognizer) {
        
        if sender.state == .ended {
            view.endEditing(true)
            if sidebarWidthConstraint.constant == 0 {
                sidebarWidthConstraint.constant = 150
            } else {
                sidebarWidthConstraint.constant = 0
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
            
            reload()
            
        }
    }
    
    @IBAction func hideSidebar(_ sender: UISwipeGestureRecognizer) {
        view.endEditing(true)
        if sidebarWidthConstraint.constant == 0 {
            sidebarWidthConstraint.constant = 150
        } else {
            sidebarWidthConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
        
        reload()
    }
    
    func reload(){
        if let homeView = rightView as? HomeView {
            if let monthView = homeView.dynamicView as? MonthView {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    monthView.loadData()
                })
            }
            
            if let weekView = homeView.dynamicView as? WeekView {
                weekView.loadData()
            }
            
            if let dayView = homeView.dynamicView as? DayView{
                dayView.loadData()
            }
        }
        
        if let eventView = rightView as? EventView{
            eventView.onLoad()
        }
        
        if let taskView = rightView as? TaskView{
            taskView.onLoad()
        }
        
        if let binView = rightView as? BinView{
            binView.onLoad()
        }
        
        if let profileView = rightView as? ProfileView{
            profileView.onLoad()
        }
    }
    
    func onSegDismiss() {
        if let home = self.rightView as? HomeView {
            home.dynamicView.loadData()
        }
        
        if let event = self.rightView as? EventView{
            event.onLoad()
        }
        
        if let task = self.rightView as? TaskView{
            task.onLoad()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let viewController = segue.destination as? AddEditViewController {
            viewController.onDismiss = onSegDismiss
            if segue.identifier == "AddEditSegueEvent" {
                viewController.isTask = false
                if let home = self.rightView as? HomeView {
                    if let day = home.dynamicView as? DayView {
                        viewController.activeDate = day.activeDate
                    }
                }
            } else if segue.identifier == "AddEditSegueTask" {
                viewController.isTask = true
            }
        }
        
        if let viewController = segue.destination as? SearchPanelViewController{
            if segue.identifier == "SearchSegue"{
                viewController.keyword = searchText.text
                viewController.eventDetailStatus = false
            }
        }
    }
    
    
    func selectedButtonEffect(selectedButton : UIButton, selectedLabel : UILabel){
        homeNavButton.alpha = 0.4
        eventNavButton.alpha = 0.4
        taskNavButton.alpha = 0.4
        binNavButton.alpha = 0.4
        profileNavButton.alpha = 0.4
        
        homeLabel.alpha = 0.4
        eventLabel.alpha = 0.4
        taskLabel.alpha = 0.4
        binLabel.alpha = 0.4
        profileLabel.alpha = 0.4
        
        selectedButton.alpha = 1
        selectedLabel.alpha = 1
    }
    
    @IBAction func onHomeClick(_ sender: Any?) {
        view.endEditing(true)
        if let newRightView = UINib(nibName: "HomeView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            HomeView {
            addButton.isHidden = false
            addButtonClosingAnimation() 
            newRightView.onLoad()
            setRightViewDetails(newRightView: newRightView)
        }
        selectedButtonEffect(selectedButton: homeNavButton, selectedLabel: homeLabel)
        
        self.homeNavButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.homeNavButton.transform = CGAffineTransform.identity
        },
                       completion: nil
        )
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        reload()
    }
    
    @IBAction func onEventClick(_ sender: UIButton) {
        view.endEditing(true)
        if let newRightView = UINib(nibName: "EventView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            EventView {
            addButton.isHidden = false
            addButtonClosingAnimation()
            newRightView.onLoad()
            setRightViewDetails(newRightView: newRightView)
        }
        selectedButtonEffect(selectedButton: eventNavButton, selectedLabel: eventLabel)
        
        sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: nil
        )
    }
    
    @IBAction func onTaskClick(_ sender: UIButton) {
        view.endEditing(true)
        if let newRightView = UINib(nibName: "TaskView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            TaskView {
            addButtonClosingAnimation()
            addButton.isHidden = false
            setRightViewDetails(newRightView: newRightView)
            newRightView.onLoad()
        }
        selectedButtonEffect(selectedButton: taskNavButton, selectedLabel: taskLabel)
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: nil
        )
    }
    
    @IBAction func onBinClick(_ sender: UIButton) {
        view.endEditing(true)
        if let newRightView = UINib(nibName: "BinView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            BinView {
            addButtonClosingAnimation()
            addButton.isHidden = true
            setRightViewDetails(newRightView: newRightView)
            newRightView.onLoad()
            
        }
        selectedButtonEffect(selectedButton: binNavButton, selectedLabel: binLabel)
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: nil
        )
    }
    
    @IBAction func profileButtonClick(_ sender: UIButton) {
        view.endEditing(true)
        if let newRightView = UINib(nibName: "ProfileView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            ProfileView {
            addButtonClosingAnimation()
            addButton.isHidden = true
            newRightView.onLoad()
            setRightViewDetails(newRightView: newRightView)
        }
        selectedButtonEffect(selectedButton: profileNavButton, selectedLabel: profileLabel)
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: nil
        )
    }
    
    func setRightViewDetails(newRightView: NavigationProtocol){
        if rightView != nil {
            rightView.removeFromSuperview()
        }
        rightView = newRightView
        rightView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(newRightView)
        rightView.frame = CGRect(x: 0, y: 0, width: rightView.frame.width, height: 1004)
        rightView.topAnchor.constraint(equalTo: searchViewTop.bottomAnchor).isActive = true
        rightView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        rightView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor).isActive = true
        rightViewTrailingToSafeArea = rightView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        rightViewTrailingToSafeArea.isActive = true
        self.view.bringSubviewToFront(eventButton)
        self.view.bringSubviewToFront(taskButton)
        self.view.bringSubviewToFront(addButton)
        
    }
    
    @IBAction func addButtonClick(_ sender: Any?) {
        addButtonAnimation()
    }
    
    func addButtonStyle(){
        addButton.layer.cornerRadius = addButton.frame.width / 2
        // Shadow and Radius
        addButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addButton.layer.shadowOffset = CGSize(width: 3.0, height: 5.0)
        addButton.layer.shadowOpacity = 1
        addButton.layer.shadowRadius = 3
        
        
    }
    
    func addButtonAnimation(){
        if(addButtonStatus == false){
            taskButton.isHidden = false
            eventButton.isHidden = false
            
            eventButtonWidth.constant = 80
            eventButtonHeight.constant = 80
            eventButtonTrailing.constant = 40
            eventButtonBottom.constant = 30
            
            taskButtonWidth.constant = 80
            taskButtonHeight.constant = 80
            taskButtonTrailing.constant = 40
            taskButtonBottom.constant = -300
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.addButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
            }
            addButtonStatus = true
        }
        else {
            
            addButtonClosingAnimation()
        }
    }
    
    func addButtonClosingAnimation(){
        eventButtonWidth.constant = 1
        eventButtonHeight.constant = 1
        eventButtonTrailing.constant = 80
        eventButtonBottom .constant = 0
        
        taskButtonWidth.constant = 1
        taskButtonHeight.constant = 1
        taskButtonTrailing.constant = 80
        taskButtonBottom.constant = -30
        
        UIView.animate(withDuration: 0.5, animations:  {
            self.addButton.transform = .identity
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.eventButton.isHidden = true
            self.taskButton.isHidden = true
        })
        
        addButtonStatus = false
    }
    
    @IBAction func addEventClick(_ sender: UIButton) {
        if(addButtonStatus == true){
            addButtonClosingAnimation()
            
        }
    }
    
    @IBAction func addTaskClick(_ sender: UIButton) {
        if(addButtonStatus == true){
            addButtonClosingAnimation()
        }
    }
    
    @IBAction func menuClick(_ sender: UIButton) {
        if sidebarWidthConstraint.constant == 0 {
            sidebarWidthConstraint.constant = 150
            menuButton.alpha = 0.1
        } else {
            sidebarWidthConstraint.constant = 0
            menuButton.alpha = 1
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.view.layoutIfNeeded()
        })
        
        reload()
    }
    
}

