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
    
    @IBAction func editButtonClick(_ sender: UIButton) {
        if let vc = getOwningViewController() as? SearchPanelViewController {
            if eventSelect{
                vc.viewEditClick(eventDetails as Any)
            }
            else{
                vc.viewEditClick(taskDetails as Any)
            }
        }
    }
    
    @IBAction func deleteButtonClick(_ sender: UIButton) {
        if eventSelect{
            if let viewController = self.getOwningViewController() as? SearchPanelViewController {
                let refreshAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this event?", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                    EventDAO().editDeleteStatus(id: self.eventDetails.id, deleteStatus:true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        if let mainController = viewController.presentingViewController as? MainViewController{
                            viewController.dismiss(animated: true, completion: {
                                if let dayView = mainController.rightView.dynamicView as? DayView{
                                    dayView.getDailyViewForDate(eventDate: self.eventDetails.startDate)
                                }
                            })
                        }
                    }
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                
                viewController.present(refreshAlert, animated: true, completion: nil)
            }
        }
        else{
            if let viewController = self.getOwningViewController() as? SearchPanelViewController {
                let refreshAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this task?", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                    TaskDAO().editDeleteStatus(id: self.taskDetails.id, deleteStatus: true)
                    viewController.getList()
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                
                viewController.present(refreshAlert, animated: true, completion: nil)
            }
        }
    }
    
    
}
