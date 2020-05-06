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
    }
    
    func style(){
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 3.0, height: 5.0)
        backgroundView.layer.shadowOpacity = 1
        backgroundView.layer.shadowRadius = 3
    }
    

}
