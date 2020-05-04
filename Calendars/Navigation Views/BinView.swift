//
//  BinView.swift
//  Calendars
//
//  Created by Rafin Rahman on 17/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class BinView: UIView, NavigationProtocol, UIGestureRecognizerDelegate {

    @IBOutlet weak var deletedStack: UIStackView!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var selectedViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var subtitleView: UIView!
    
    var dynamicView: CalendarProtocol!
    
    func onLoad() {
        loadDeletedEvents()
    }
    
    func loadDeletedEvents() {
        deletedStack.removeAllArrangedSubviews()
        let eventDAO = EventDAO()
        eventDAO.getAllDeletedEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showDeletedEvents(deletedEventList: eventDAO.eventList)
        }
    }
    
    func loadDeletedTask(){
        deletedStack.removeAllArrangedSubviews()
        let taskDAO = TaskDAO()
        taskDAO.getAllDeletedTask()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showDeletedTasks(deletedTaskList: taskDAO.taskList)
        }
    }

    func showDeletedEvents(deletedEventList : Array<Events>){
        for deletedEvent in deletedEventList{
            if let deletedEventView = UINib(nibName: "BinRowView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? BinRowView {
                deletedEventView.translatesAutoresizingMaskIntoConstraints = false
                deletedStack.addArrangedSubview(deletedEventView)
                deletedEventView.heightAnchor.constraint(equalToConstant: 60).isActive = true
                deletedEventView.selectedEvent = deletedEvent
                deletedEventView.setDetailsOfEvent()
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(onTapEvent(_:)))
                singleTap.delegate = self
                deletedEventView.addGestureRecognizer(singleTap)
            }
        }
    }
    
    func showDeletedTasks(deletedTaskList : Array<Task>){
        for deletedTask in deletedTaskList{
            if let deletedTaskView = UINib(nibName: "BinRowView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? BinRowView {
                deletedTaskView.translatesAutoresizingMaskIntoConstraints = false
                deletedStack.addArrangedSubview(deletedTaskView)
                deletedTaskView.heightAnchor.constraint(equalToConstant: 60).isActive = true
                deletedTaskView.selectedTask = deletedTask
                deletedTaskView.setDetailsOfTask()
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(onTapTask(_:)))
                singleTap.delegate = self
                deletedTaskView.addGestureRecognizer(singleTap)
            }
        }
    }
    
    @objc func onTapEvent(_ sender : UITapGestureRecognizer) {
        if let event = sender.view as? BinRowView {
            let optionAlert = UIAlertController(title: "Options...", message: "Choose please", preferredStyle: .alert)
            
            optionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                // do nothing
            }))
            
            optionAlert.addAction(UIAlertAction(title: "Restore", style: .default, handler: { (action: UIAlertAction) in
                EventDAO().editDeleteStatus(id: event.selectedEvent.id, deleteStatus: false)
                self.loadDeletedEvents()
            }))
            
            optionAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction) in
                EventDAO().deleteEvent(eventId: event.selectedEvent.id)
                self.loadDeletedEvents()
                
            }))
            
            if let viewController = getOwningViewController() as? MainViewController {
                viewController.present(optionAlert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func onTapTask(_ sender : UITapGestureRecognizer) {
           if let task = sender.view as? BinRowView {
               let optionAlert = UIAlertController(title: "Options...", message: "Choose please", preferredStyle: .alert)
               
               optionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                   // do nothing
               }))
               
               optionAlert.addAction(UIAlertAction(title: "Restore", style: .default, handler: { (action: UIAlertAction) in
                   TaskDAO().editDeleteStatus(id: task.selectedTask.id, deleteStatus: false)
                   self.loadDeletedTask()
               }))
               
               optionAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction) in
                   TaskDAO().deleteTask(taskId: task.selectedTask.id)
                   self.loadDeletedTask()
               }))
               
               if let viewController = getOwningViewController() as? MainViewController {
                   viewController.present(optionAlert, animated: true, completion: nil)
               }
           }
       }
    
    
    @IBAction func eventButtonClick(_ sender: UIButton) {
        selectedViewConstraint.constant = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.subtitleView.layoutIfNeeded()
        })
        loadDeletedEvents()
    }
    
    @IBAction func taskButtonClick(_ sender: UIButton) {
        selectedViewConstraint.constant = sender.frame.origin.x
        UIView.animate(withDuration: 0.2, animations: {
            self.subtitleView.layoutIfNeeded()
        })
        loadDeletedTask()
    }
    
}
