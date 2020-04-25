//
//  HomeView.swift
//  Calendars
//
//  Created by Rafin Rahman on 16/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class HomeView: UIView, NavigationProtocol {
    
    @IBOutlet weak var currentDate: UILabel!
    var dynamicView: CalendarProtocol!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var dayButton: UIButton!
    
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var barHeight: NSLayoutConstraint!
    @IBOutlet weak var barXCenter: NSLayoutConstraint!
    @IBOutlet weak var barWidth: NSLayoutConstraint!
    
    
    var open = false;
    
    func onLoad() {
        let format = DateFormatter()
        format.dateFormat = "E, dd MMMM YYYY"
        self.currentDate.text = format.string(from: Calendar.current.date(byAdding: .day, value: 0, to: Date())!)
        onDayClick(dayButton)
    }
    
    @IBAction func onDayClick(_ sender: UIButton) {
        setBarStyle(sender: sender)
        
        if let dayView = UINib(nibName: "DayView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            DayView{
            setDayView(newView : dayView)
            dayView.rightScroll.delegate = dayView
            dayView.leftScroll.delegate = dayView
            dayView.getDailyView(eventDate: Date())
        }
    }
    
    @IBAction func onWeekClick(_ sender: UIButton) {
        setBarStyle(sender: sender)
        
        if let weekView = UINib(nibName: "WeekView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            WeekView{
            setDayView(newView : weekView)
            weekView.topScroll.delegate = weekView
            weekView.rightScroll.delegate = weekView
            weekView.leftScroll.delegate = weekView
        }
    }
    
    @IBAction func onMonthClick(_ sender: UIButton) {
        setBarStyle(sender: sender)
        
        if let monthView = UINib(nibName: "MonthView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            MonthView{
            setDayView(newView : monthView)
        }
    }
    
    @IBAction func onYearClick(_ sender: UIButton) {
        setBarStyle(sender: sender)
        
        if let yearView = UINib(nibName: "YearView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            YearView{
            setDayView(newView : yearView)
        }
    }
    
    func setBarStyle(sender: UIButton) {
        barHeight.constant = 5
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
    
  
    @IBAction func searchTextEdited(_ sender: UITextField) {
        if let vc = self.getOwningViewController() as? MainViewController {
          
        }
    }
    
  
    
    
}
