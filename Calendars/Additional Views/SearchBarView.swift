//
//  SearchBarView.swift
//  Calendars
//
//  Created by Rafin Rahman on 05/05/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class SearchBarView: UIView {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var optionViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var singleTapGesture: UITapGestureRecognizer!
    
    var eventSelect:Bool!
    var eventDetails:Events!
    var taskDetails:Task!
    var singleTapGestureTaskChange = false
    
    func setDataForEvents(event:Events){
        dateLabel.text = event.startDate.toString(dateFormat: "dd MMM YY")
        
        if event.allDay{
            timeLabel.text = "All Day"
        }
        else{
            let startTime = event.startDate.toString(dateFormat: "HH:mm")!
            let endTime = event.endDate.toString(dateFormat: "HH:mm")!
            timeLabel.text = startTime + " - " + endTime
        }
        
        nameLabel.text = event.eventName
        profileLabel.text = event.profile
        label.text = "Event"
        backgroundView.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "#fffa65", alpha: 1)
        eventDetails = event
        eventSelect = true
    }
    
    func setDataForTasks(task:Task){
        dateLabel.text = task.taskDateAndTime.toString(dateFormat: "dd MMM YY")
        timeLabel.text = task.taskDateAndTime.toString(dateFormat: "HH:mm")
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: task.taskName)
        if task.completedStatus{
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        }
              
        nameLabel.attributedText = attributeString
        profileLabel.text = task.profile
        label.text = "Task"
        backgroundView.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "#7bed9f", alpha: 1)
        taskDetails = task
        eventSelect = false
    }
    
    func setDataForTasksDifferentBackGround(task:Task){
        singleTapGestureTaskChange = true
        dateLabel.text = task.taskDateAndTime.toString(dateFormat: "dd MMM YY")
        timeLabel.text = task.taskDateAndTime.toString(dateFormat: "HH:mm")
        
        if task.completedStatus{
            backgroundView.backgroundColor = .green
            label.text = "Completed"
        }
        else{
            backgroundView.backgroundColor = .red
            label.text = "To-do"
        }
              
        nameLabel.text = task.taskName
        profileLabel.text = task.profile
               
        taskDetails = task
        eventSelect = false
    }
    
    func style(){
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 3.0, height: 5.0)
        backgroundView.layer.shadowOpacity = 1
        backgroundView.layer.shadowRadius = 3
    }

    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        self.optionViewTrailing.constant = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        self.optionViewTrailing.constant = -120
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        if singleTapGestureTaskChange{
            if let viewController = self.getOwningViewController() as? SearchPanelViewController {
                let taskDao = TaskDAO()
                taskDao.editTaskCompleted(taskId: taskDetails.id, completed: !taskDetails.completedStatus)
                taskDao.getAllTasksFromDays(startDate: taskDetails.taskDateAndTime.stripTime(), endDate: Calendar.current.date(byAdding: .day, value: 1, to: taskDetails.taskDateAndTime.stripTime())!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    viewController.getTaskDetails(tasks: taskDao.taskList, activeDate: self.taskDetails.activeDate)
                }
            }
        }
        else{
            if let vc = getOwningViewController() as? SearchPanelViewController {
                if eventSelect{
                    vc.clickEventOrTask(eventDetails as Any)
                }
                else{
                    vc.clickEventOrTask(taskDetails as Any)
                }
            }
        }
    }
    
    @IBAction func editButtonClick(_ sender: UIButton) {
        if let vc = getOwningViewController() as? SearchPanelViewController {
            if eventSelect{
                vc.viewEditClick(eventDetails as Any)
            }
            else{
                vc.viewEditClick(taskDetails as Any)
            }
        }
    }
    
    
    @IBAction func deleteButtonClick(_ sender: UIButton) {
        if eventSelect{
            if let viewController = self.getOwningViewController() as? SearchPanelViewController {
                let refreshAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this event?", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                    EventDAO().editDeleteStatus(id: self.eventDetails.id, deleteStatus:true)
                    viewController.getList()
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                
                viewController.present(refreshAlert, animated: true, completion: nil)
            }
        }
        else{
            if let viewController = self.getOwningViewController() as? SearchPanelViewController {
                let refreshAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this task?", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                    TaskDAO().editDeleteStatus(id: self.taskDetails.id, deleteStatus: true)
                    viewController.getList()
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                
                viewController.present(refreshAlert, animated: true, completion: nil)
            }
        }
    }
    
    
}
