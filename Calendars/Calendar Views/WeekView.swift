//
//  WeekView.swift
//  Calendars
//
//  Created by Rafin Rahman on 12/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class WeekView: UIView, CalendarProtocol, UIScrollViewDelegate {
    
    @IBOutlet weak var dayZero: UILabel!
    @IBOutlet weak var dayOneButton: UIButton!
    @IBOutlet weak var dayTwoButton: UIButton!
    @IBOutlet weak var dayThreeButton: UIButton!
    @IBOutlet weak var dayFourButton: UIButton!
    @IBOutlet weak var dayFiveButton: UIButton!
    @IBOutlet weak var daySixButton: UIButton!
    @IBOutlet weak var daySevenButton: UIButton!
    
    @IBOutlet weak var weekLabel: UILabel!
    
    @IBOutlet weak var rightScroll: UIScrollView!
    @IBOutlet weak var leftScroll: UIScrollView!
    @IBOutlet weak var taskBarView: UIView!
    
    var activeDate: Date = Date()
    
    var eventView : Array<UIView> = Array()
    var allDayListView : Array<UIView> = Array()
    var taskView:Array<UIView> = Array()
    
    var savedGestureEvent : EventGestureRecognizer!
    var savedGestureTask : TaskGestureRecognizer!

    func loadData() {
        getWeeklyView(date: Date())
    }
    
    func getWeeklyView(date:Date){
        getDates(date: date)
        noTask()
    }
    
    func clearAllTask(){
        for subview in self.taskView {
            subview.removeFromSuperview()
        }
    }
    
    func noTask(){
        if savedGestureTask != nil {
            taskBarView.removeGestureRecognizer(savedGestureTask)
        }
        let message = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
        
        message.text = "No Task Scheduled"
        
        message.textColor = UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1)
        message.font = UIFont.systemFont(ofSize: 17)
        
        self.taskBarView.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "#EFF2F5", alpha: 1.0)
        self.taskBarView.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        
        self.taskView.append(message)
        self.taskBarView.addSubview(message)
        
        message.topAnchor.constraint(equalTo: self.taskBarView.topAnchor, constant: 10).isActive = true
        message.leadingAnchor.constraint(equalTo: self.taskBarView.leadingAnchor, constant: 20).isActive = true
        message.trailingAnchor.constraint(equalTo: self.taskBarView.trailingAnchor, constant: -10).isActive = true
        message.bottomAnchor.constraint(equalTo: self.taskBarView.bottomAnchor, constant: -10).isActive = true
        message.numberOfLines = 0
    }
    
    
    
    // Syncronize scroll views position
    func synchronizeScrollViewY(_ scrollViewToScroll: UIScrollView, toScrollView scrolledView: UIScrollView){
        var yPosition = scrollViewToScroll.contentOffset
        yPosition.y = scrolledView.contentOffset.y
        scrollViewToScroll.setContentOffset(yPosition, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == rightScroll{
            self.synchronizeScrollViewY(leftScroll, toScrollView: rightScroll)
        }
            
        else if scrollView == leftScroll{
            self.synchronizeScrollViewY(rightScroll, toScrollView: leftScroll)
        }
    }
    
    @IBAction func previousButtonClick(_ sender: UIButton) {
        let date = dayZero.text!.toDate(dateFormat: "dd-MM-yy")!
        getDates(date: Calendar.current.date(byAdding: .day, value: -7, to: date)!)
    }
    
    @IBAction func nextButtonClick(_ sender: UIButton) {
        let date = dayZero.text!.toDate(dateFormat: "dd-MM-yy")!
        getDates(date: Calendar.current.date(byAdding: .day, value: 7, to: date)!)
    }
    
    func getDates(date:Date){
        let newFormat = DateFormatter()
        newFormat.dateFormat = "dd-MM-yy"
        
        let format = DateFormatter()
        format.dateFormat = "d E"
        
        weekLabel.text = "Week "+String(Calendar.current.component(.weekOfMonth, from: date)) + "\n" + date.toString(dateFormat: "MMM")
        weekLabel.adjustsFontSizeToFitWidth = true
        weekLabel.numberOfLines = 2
                
        dayZero.text = newFormat.string(from: Calendar.current.date(byAdding: .day, value: 0, to: date)!)
        
        dayOneButton.setTitle(format.string(from: Calendar.current.date(byAdding: .day, value: 0, to: date)!), for: .normal)
        dayOneButton.tag = 0
        
        dayTwoButton.setTitle(format.string(from: Calendar.current.date(byAdding: .day, value: 1, to: date)!), for: .normal)
        dayTwoButton.tag = 1
        
        dayThreeButton.setTitle(format.string(from: Calendar.current.date(byAdding: .day, value: 2, to: date)!), for: .normal)
        dayThreeButton.tag = 2
        
        dayFourButton.setTitle(format.string(from: Calendar.current.date(byAdding: .day, value: 3, to: date)!), for: .normal)
        dayFourButton.tag = 3
        
        dayFiveButton.setTitle(format.string(from: Calendar.current.date(byAdding: .day, value: 4, to: date)!), for: .normal)
        dayFiveButton.tag = 4
        
        daySixButton.setTitle(format.string(from: Calendar.current.date(byAdding: .day, value: 5, to: date)!), for: .normal)
        daySixButton.tag = 5
        
        daySevenButton.setTitle(format.string(from: Calendar.current.date(byAdding: .day, value: 6, to: date)!), for: .normal)
        daySevenButton.tag = 6
    }
    
    @IBAction func dayButtonClick(_ sender: UIButton) {
        if let homeView = self.superview as? HomeView{
            let newFormat = DateFormatter()
            newFormat.dateFormat = "dd-MM-yy"
            let selectedDate = dayZero.text as! String
            let convertedToDate = Calendar.current.date(byAdding: .day, value: sender.tag, to: newFormat.date(from: selectedDate)!)!
            print("Converted", convertedToDate)
            homeView.getDayView(date: convertedToDate)
        }
    }
    
}


