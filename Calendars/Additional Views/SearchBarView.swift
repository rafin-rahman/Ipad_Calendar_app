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
    
    var eventSelect:Bool!
    var eventDetails:Events!
    var taskDetails:Task!
    
    func setDataForEvents(event:Events){
        dateLabel.text = event.startDate.toString(dateFormat: "dd MMM YY")
        
        if event.allDay{
            timeLabel.text = "All Day"
        }
        else{
            let startTime = event.startDate.toString(dateFormat: "hh:mm")!
            let endTime = event.endDate.toString(dateFormat: "hh:mm")!
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
        timeLabel.text = task.taskDateAndTime.toString(dateFormat: "hh:mm")
        
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
    
    func style(){
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 3.0, height: 5.0)
        backgroundView.layer.shadowOpacity = 1
        backgroundView.layer.shadowRadius = 3
    }

    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        self.optionViewTrailing.constant = 0
        UIView.animate(withDuration: 3, animations: {
            self.optionView.layoutIfNeeded()
        })
        
        
    }
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        self.optionViewTrailing.constant = -120
        UIView.animate(withDuration: 3, animations: {
            
            self.optionView.layoutIfNeeded()
        })
    }
}
