//
//  BinRowView.swift
//  Calendars
//
//  Created by Rafin Rahman on 02/05/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class BinRowView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var selectedEvent: Events!
    var selectedTask : Task!
        
    func setDetailsOfEvent(){
            nameLabel.text = selectedEvent.eventName
            dateLabel.text = selectedEvent.startDate.toString(dateFormat: "dd MMM YYYY")
    }
    
    func setDetailsOfTask(){
            nameLabel.text = selectedTask.taskName
            dateLabel.text = selectedTask.taskDateAndTime.toString(dateFormat: "dd MMM YYYY")
    }
    
}
