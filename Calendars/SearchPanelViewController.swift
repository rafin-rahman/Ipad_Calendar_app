//
//  SearchPanelViewController.swift
//  Calendars
//
//  Created by Rafin Rahman on 25/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit
import Firebase

class SearchPanelViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var searchBarTrailing: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var leftView: UIView!
    
    var keyword:String!
    var searchedWord:String!
    var searchedEventList:Array<Events>!
    var onDismiss : ((_ object: Any?) -> Void)?
    
    var eventDetailStatus = true
    var activeDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        tap.delegate = self
        self.backgroundView.addGestureRecognizer(tap)
        
        searchView.layer.cornerRadius = 6.0
        searchView.layer.masksToBounds = true
        searchField.text = keyword
        searchField.delegate = self
        if !eventDetailStatus{
            getSearchBar()
            getList()
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchedWord = textField.text!
        getList()
        return true
    }
    
    func getSearchBar(){
        searchBarTrailing.constant = -450
        UIView.animate(withDuration: 0, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            
            self.searchBarTrailing.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        })
    }
    
    func getList(){
        let eventDAO = EventDAO()
        let taskDAO = TaskDAO()
        eventDAO.getAllEvents()
        taskDAO.getAllTask()
        if searchedWord != nil {
            keyword = searchedWord
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.stackView.removeAllArrangedSubviews()
            if self.keyword != nil {
                for event in eventDAO.eventList{
                    if event.eventName.contains(self.keyword){
                        self.getSearchViewForEvent(eventDetails: event)
                    }
                }
                
                for task in taskDAO.taskList{
                    if task.taskName.contains(self.keyword){
                        self.getSearchViewForTask(taskDetails: task)
                    }
                }
            }
        }
    }
    
    func getEventDetails(event:Events){
        self.stackView.removeAllArrangedSubviews()
        showEventDetails(event: event)
    }
    
    func getEventDetails(events:Array<Events>){
        self.stackView.removeAllArrangedSubviews()
        for event in events{
            showEventDetails(event: event)
        }
    }
    
    func getTaskDetails(tasks:Array<Task>){
        self.stackView.removeAllArrangedSubviews()
        activeDate = tasks[0].taskDateAndTime.stripTime()
        for task in tasks{
            getSearchViewForTaskDifferentBackground(taskDetails: task)
        }
    }
    
    func getTaskDetails(tasks:Array<Task>, activeDate:Date){
        self.stackView.removeAllArrangedSubviews()
        self.activeDate = activeDate
        for task in tasks{
            task.activeDate = activeDate
            getSearchViewForTaskDifferentBackground(taskDetails: task)
        }
    }
    
    func showEventDetails(event:Events){
        if let detailsView = UINib(nibName: "DetailView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? DetailView {
            detailsView.style()
            detailsView.translatesAutoresizingMaskIntoConstraints = false
            leftView.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "273C75", alpha: 1)
            searchView.isHidden = true
            detailsView.setDataForEvents(event: event)
            stackView.addArrangedSubview(detailsView)
            detailsView.heightAnchor.constraint(equalToConstant: 500).isActive = true
            self.activeDate = event.startDate
        }
    }
    
    func getSearchViewForEvent(eventDetails:Events){
        if let searchBarView = UINib(nibName: "SearchBarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? SearchBarView {
            searchBarView.style()
            searchBarView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(searchBarView)
            searchBarView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            searchBarView.setDataForEvents(event: eventDetails)
        }
    }
    
    func getSearchViewForTask(taskDetails:Task){
        if let searchBarView = UINib(nibName: "SearchBarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? SearchBarView {
            searchBarView.style()
            searchBarView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(searchBarView)
            searchBarView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            searchBarView.setDataForTasks(task: taskDetails)
        }
    }
    
    func getSearchViewForTaskDifferentBackground(taskDetails:Task){
        if let searchBarView = UINib(nibName: "SearchBarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? SearchBarView {
            searchBarView.style()
            searchBarView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(searchBarView)
            searchBarView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            searchBarView.setDataForTasksDifferentBackGround(task: taskDetails)
        }
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        if let vc = self.presentingViewController as? MainViewController{
            dismiss(animated: true, completion:{
                if let dayView = vc.rightView.dynamicView as? DayView {
                    dayView.getDailyViewForDate(eventDate: self.activeDate)
                }
                else if let weekView = vc.rightView.dynamicView as? WeekView{
                    weekView.getWeeklyView(date: self.activeDate)
                }
                
            })
        }
        
    }
    
    public func clickEventOrTask(_ object: Any) {
        if let vc = self.presentingViewController as? MainViewController {
            dismiss(animated: true, completion: {
                if let dayView = vc.rightView.dynamicView as? DayView {
                    if let event = object as? Events{
                        dayView.getDailyViewForDate(eventDate: event.startDate)
                    }
                    if let task = object as? Task{
                        dayView.getDailyViewForDate(eventDate: task.taskDateAndTime)
                    }
                }
                if let weekView = vc.rightView.dynamicView as? WeekView {
                    if let event = object as? Events{
                        weekView.getWeeklyView(date: event.startDate)
                    }
                    
                    if let task = object as? Task{
                        weekView.getWeeklyView(date: task.taskDateAndTime)
                    }
                }
                
            })
        }
    }
    
    public func viewEditClick(_ object: Any) {
        if let vc = self.presentingViewController as? MainViewController {
            dismiss(animated: true, completion: {
                if let dayView = vc.rightView.dynamicView as? DayView {
                    dayView.onSegDismiss(object)
                }
                if let weekView = vc.rightView.dynamicView as? WeekView {
                    weekView.onSegDismiss(object)
                }
            })
        }
    }
    
}
