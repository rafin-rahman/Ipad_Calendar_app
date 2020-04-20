//
//  HomeView.swift
//  Calendars
//
//  Created by Rafin Rahman on 16/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class HomeView: UIView {
    
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var dynamicView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var taskButton: UIButton!
    @IBOutlet weak var eventButton: UIButton!
    
    
    // task and event contraints
    @IBOutlet weak var eventButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var eventButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var eventButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var eventButtonBottom: NSLayoutConstraint!
    
    @IBOutlet weak var taskButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var taskButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var taskButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var taskButtonBottom: NSLayoutConstraint!
    
    
    
    
    
    var open = false;
    
    func onLoad() {
        addButtonStyle()
        let format = DateFormatter()
        format.dateFormat = "E, dd MMMM YYYY"
        self.currentDate.text = format.string(from: Calendar.current.date(byAdding: .day, value: 0, to: Date())!)
        onDayClick(nil)
        
        
    }
    
    @IBAction func onDayClick(_ sender: Any?) {
        if let dayView = UINib(nibName: "DayView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            DayView{
            setDayView(newView : dayView)
            dayView.rightScroll.delegate = dayView
            dayView.leftScroll.delegate = dayView
            dayView.getDailyView()
        }
    }
    
    @IBAction func onWeekClick(_ sender: UIButton) {
        if let weekView = UINib(nibName: "WeekView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            WeekView{
            setDayView(newView : weekView)
            weekView.topScroll.delegate = weekView
            weekView.rightScroll.delegate = weekView
            weekView.leftScroll.delegate = weekView
        }
    }
    
    @IBAction func onMonthClick(_ sender: UIButton) {
        if let monthView = UINib(nibName: "MonthView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            MonthView{
            setDayView(newView : monthView)
        }
    }
    
    @IBAction func onYearClick(_ sender: UIButton) {
        if let yearView = UINib(nibName: "YearView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            YearView{
            setDayView(newView : yearView)
        }
    }
    
    func setDayView(newView: UIView){
        dynamicView.removeFromSuperview()
        dynamicView = newView
        dynamicView.translatesAutoresizingMaskIntoConstraints = false
        dynamicView.frame = CGRect(x: 0, y: 0, width: dynamicView.frame.width, height: dynamicView.frame.height)
        self.addSubview(dynamicView)
        dynamicView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        dynamicView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dynamicView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        dynamicView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        // Set layer at the front
        bringSubviewToFront(eventButton)
        bringSubviewToFront(taskButton)
        bringSubviewToFront(addButton)
    }
    
    @IBAction func addButtonClick(_ sender: Any?) {
        addButtonAnimation()
        
    }
    
    func addButtonStyle(){
        addButton.layer.cornerRadius = addButton.frame.width / 2
        // Shadow and Radius
        addButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addButton.layer.shadowOffset = CGSize(width: 3.0, height: 5.0)
        addButton.layer.shadowOpacity = 1
        addButton.layer.shadowRadius = 3
        //addButton.layer.masksToBounds = false
    }
    
    func addButtonAnimation(){
        if(open == false){
            
            taskButton.isHidden = false
            eventButton.isHidden = false
            
            eventButtonWidth.constant = 80
            eventButtonHeight.constant = 80
            eventButtonTrailing.constant = 40
            eventButtonBottom.constant = 30
            
            taskButtonWidth.constant = 80
            taskButtonHeight.constant = 80
            taskButtonTrailing.constant = 40
            taskButtonBottom.constant = 30
            
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
                self.addButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
            }
            
            open = true
        }
        else {
            
            eventButtonWidth.constant = 1
            eventButtonHeight.constant = 1
            eventButtonTrailing.constant = 80
            eventButtonBottom .constant = -30
            
            taskButtonWidth.constant = 1
            taskButtonHeight.constant = 1
            taskButtonTrailing.constant = 80
            taskButtonBottom.constant = -30
            
            UIView.animate(withDuration: 0.5, animations:  {
                self.addButton.transform = .identity
                self.layoutIfNeeded()
            }, completion: { _ in
                self.eventButton.isHidden = true
                self.taskButton.isHidden = true
            })
            
            open = false
        }
    }
    
    
}
