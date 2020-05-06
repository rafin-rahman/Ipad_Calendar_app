//
//  SearchPanelViewController.swift
//  Calendars
//
//  Created by Rafin Rahman on 25/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit
import Firebase

class SearchPanelViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var searchBarTrailing: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var searchField: UITextField!
    
    var keyword:String!
    var searchedWord:String!
    var searchedEventList:Array<Events>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.text = keyword
        searchField.delegate = self
        getSearchBar()
        getList()
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        self.backgroundView.addGestureRecognizer(tap)
        
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
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }


}
