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
    
    func del() {
        if let event = selectedEvent as? Events {
            
        }
    }
    
    func setDetails(){
            nameLabel.text = selectedEvent.eventName
            dateLabel.text = selectedEvent.startDate.toString(dateFormat: "dd MMM YYYY")
    }
    

    
}
