//
//  MonthCellView.swift
//  Calendars
//
//  Created by Rafin Rahman on 29/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

@IBDesignable

class MonthCellView: UICollectionViewCell {
    
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var eventNumberLabel: UILabel!
    @IBOutlet weak var taskNumberLabel: UILabel!
    @IBOutlet weak var dayNumberLabel: UILabel!
    
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var taskView: UIView!
    
    func clearDate(){
        eventView.isHidden = true
        taskView.isHidden = true
        dayNumberLabel.isHidden = true
    }
    
    
    func populateData(dayNumber:Int, eventNumber:Int, taskNumber:Int){
        dayNumberLabel.text = String(dayNumber)
        eventNumberLabel.text = String(eventNumber)
        taskNumberLabel.text = String(taskNumber)
    }
}
