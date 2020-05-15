//
//  MonthCellView.swift
//  Calendars
//
//  Created by Rafin Rahman on 29/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

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
        self.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "EFF2F5", alpha: 1.0)
    }
    
    
    func populateData(dayNumber:Int, eventNumber:Int, taskNumber:Int){
        dayNumberLabel.text = String(dayNumber)
        
        if eventNumber == 0{
            eventView.isHidden = true
        }
        else{
            eventNumberLabel.text = String(eventNumber)
        }
        
        
        if taskNumber == 0{
            taskView.isHidden = true
        }
        else{
            taskNumberLabel.text = String(taskNumber)
        }
        
        
    }
}
