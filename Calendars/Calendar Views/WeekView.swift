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
    
    var activeDate: Date = Date()
    
    var eventView : Array<UIView> = Array()
    var allDayListView : Array<UIView> = Array()
    var taskView:Array<UIView> = Array()
    
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
        
        clearAllTask()
        
        let taskDAO = TaskDAO()
        
        taskDAO.getAllTasksFromDays(startDate: date.stripTime(), endDate: (Calendar.current.date(byAdding: .day, value: 8, to: date)?.stripTime())!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.displayAllTaskForDays(taskDict: self.sortTaskAccordingToDate(tasks: taskDAO.taskList))
        }
    }
    
    func clearAllTask(){
        for subview in self.taskView {
            subview.removeFromSuperview()
        }
    }
    
    func sortTaskAccordingToDate(tasks:Array<Task>) -> Dictionary<Date, Array<Task>>{
        var taskDict : Dictionary <Date, Array<Task>> = Dictionary()
        for task in tasks{
            taskDict[task.taskDateAndTime.stripTime(), default: []].append(task)
        }
        return taskDict
    }
    
    func displayAllTaskForDays(taskDict:Dictionary<Date,Array<Task>>){
        let sortedDic = taskDict.sorted { (firstDic, secondDic) -> Bool in
            return firstDic.key < secondDic.key
        }
        
        for (date, listOfTask) in sortedDic{
            if savedGestureTask != nil {
                taskBarView.removeGestureRecognizer(savedGestureTask)
            }
            
            let taskView = TempConstraintView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            taskView.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "#8395a7", alpha: 1.0)
            
            var counter = 0
            for task in listOfTask{
                if !task.completedStatus{
                    counter += 1
                }
            }
            
            let tapGesture = TaskGestureRecognizer(target: self, action: #selector(displayTaskListOfDetail(_:)))
            tapGesture.taskList = listOfTask
            tapGesture.delegate = self
            savedGestureTask = tapGesture
            taskView.addGestureRecognizer(tapGesture)
                     
            let message = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            message.text = String(counter) + " of " + String(listOfTask.count)
            message.textColor = .white
            message.font = UIFont.systemFont(ofSize: 17)
            
            taskStackView.addArrangedSubview(taskView)
            taskView.addSubview(message)
            
            taskView.translatesAutoresizingMaskIntoConstraints = false
            message.translatesAutoresizingMaskIntoConstraints = false
            
            taskView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            message.centerYAnchor.constraint(equalTo: taskView.centerYAnchor, constant: 0).isActive = true
            message.centerXAnchor.constraint(equalTo: taskView.centerXAnchor, constant: 0).isActive = true
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
    }
    
    @IBAction func nextButtonClick(_ sender: UIButton) {
        let date = dayZero.text!.toDate(dateFormat: "dd-MM-yy")!
        getDates(date: Calendar.current.date(byAdding: .day, value: 7, to: date)!)
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
            let selectedDate = dayZero.text as! String
            let convertedToDate = Calendar.current.date(byAdding: .day, value: sender.tag, to: newFormat.date(from: selectedDate)!)!
            print("Converted", convertedToDate)
            homeView.getDayView(date: convertedToDate)
        }
    }
    
}


