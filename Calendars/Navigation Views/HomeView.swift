//
//  HomeView.swift
//  Calendars
//
//  Created by Rafin Rahman on 16/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class HomeView: UIView, NavigationProtocol {
    
    var dynamicView: CalendarProtocol!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var dayButton: UIButton!
    
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var barHeight: NSLayoutConstraint!
    @IBOutlet weak var barXCenter: NSLayoutConstraint!
    @IBOutlet weak var barWidth: NSLayoutConstraint!
    @IBOutlet weak var todayButton: UIButton!
    
    var open = false;
    
    func onLoad() {
        todayButton.setTitle(Date().toString(dateFormat: "E, dd MMM YYYY"), for: .normal)
        todayButton.titleLabel?.adjustsFontSizeToFitWidth = true
        onDayClick(dayButton)
    }
    
    @IBAction func onDayClick(_ sender: UIButton) {
        setBarStyle(sender: sender)
        
        if let dayView = UINib(nibName: "DayView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            DayView{
            setDayView(newView : dayView)
            dayView.rightScroll.delegate = dayView
            dayView.leftScroll.delegate = dayView
            dayView.loadData()
        }
    }
    
    @IBAction func onWeekClick(_ sender: UIButton) {
        setBarStyle(sender: sender)
        
        if let weekView = UINib(nibName: "WeekView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            WeekView{
            setDayView(newView : weekView)
            weekView.rightScroll.delegate = weekView
            weekView.leftScroll.delegate = weekView
            weekView.loadData()
        }
    }
    
    @IBAction func onMonthClick(_ sender: UIButton) {
        setBarStyle(sender: sender)
        
        if let monthView = UINib(nibName: "MonthView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            MonthView{
            setDayView(newView : monthView)
            monthView.loadData()
        }
    }
    
    @IBAction func onYearClick(_ sender: UIButton) {
        setBarStyle(sender: sender)
        
        if let yearView = UINib(nibName: "YearView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            YearView{
            setDayView(newView : yearView)
            yearView.loadData()
        }
    }
    
    func setBarStyle(sender: UIButton) {
        barHeight.constant = 3
        barXCenter.isActive = false
        barXCenter = barView.centerXAnchor.constraint(equalTo: sender.centerXAnchor)
        barXCenter.isActive = true
        barWidth.constant = sender.bounds.width
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
    }
    
    func setDayView(newView: CalendarProtocol){
        if dynamicView != nil {
            dynamicView.removeFromSuperview()
        }
        dynamicView = newView
        dynamicView.translatesAutoresizingMaskIntoConstraints = false
        dynamicView.frame = CGRect(x: 0, y: 0, width: dynamicView.frame.width, height: dynamicView.frame.height)
        self.addSubview(dynamicView)
        dynamicView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        dynamicView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dynamicView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        dynamicView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    @IBAction func todayButtonClick(_ sender: UIButton) {
        setBarStyle(sender:dayButton)
        if let dayView = UINib(nibName: "DayView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            DayView{
            setDayView(newView : dayView)
            dayView.rightScroll.delegate = dayView
            dayView.leftScroll.delegate = dayView
            dayView.getDailyView(eventDate: Date())
        }
    }
    
    func getDayView(date:Date){
        setBarStyle(sender: dayButton)
        if let dayView = UINib(nibName: "DayView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            DayView{
            setDayView(newView : dayView)
            dayView.rightScroll.delegate = dayView
            dayView.leftScroll.delegate = dayView
            dayView.getDailyView(eventDate: date)
        }
    }
    
}
