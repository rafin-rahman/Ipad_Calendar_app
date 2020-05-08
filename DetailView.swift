//
//  DetailView.swift
//  
//
//  Created by Rafin Rahman on 06/05/2020.
//

import UIKit

class DetailView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventTaskNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var locationImg: UIImageView!
    
    var eventSelect:Bool!
    var eventDetails:Events!
    var taskDetails:Task!
    
    func setDataForEvents(event:Events){
        dateLabel.text = event.startDate.toString(dateFormat: "dd MMM YY")
        eventTaskNameLabel.text = event.eventName
        locationLabel.text = event.location
        if event.location == "" {
            locationImg.isHidden = true
        }
        
        if event.allDay{
            timeLabel.text = "All Day"
        }
        else{
            let startTime = event.startDate.toString(dateFormat: "HH:mm")!
            let endTime = event.endDate.toString(dateFormat: "HH:mm")!
            timeLabel.text = startTime + " - " + endTime
        }
        
        let reminder = event.startDate.timeIntervalSince(event.reminder)
        
        reminderLabel.text = Date(timeIntervalSince1970: reminder-3600).toString(dateFormat: "HH") + " hours  " + Date(timeIntervalSince1970: reminder-3600).toString(dateFormat: "mm") + " minutes before"
        priorityLabel.text = event.priority
        profileLabel.text = event.profile
        
        eventDetails = event
        eventSelect = true
    }
    
    func style(){
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 3.0, height: 5.0)
        backgroundView.layer.shadowOpacity = 1
        backgroundView.layer.shadowRadius = 3
    }
    
}
