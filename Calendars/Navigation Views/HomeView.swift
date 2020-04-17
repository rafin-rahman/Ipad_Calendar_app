//
//  HomeView.swift
//  Calendars
//
//  Created by Rafin Rahman on 16/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class HomeView: UIView {

    @IBOutlet weak var dynamicView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    
    
    
    
    @IBAction func onDayCick(_ sender: Any?) {
        if let dayView = UINib(nibName: "DayView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            DayView{
            setDayView(dayView : dayView)
        }
    }
    
    @IBAction func onWeekClick(_ sender: UIButton) {
        if let dayView = UINib(nibName: "WeekView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
                   WeekView{
                   setDayView(dayView : dayView)
               }
    }
    
    @IBAction func onMonthClick(_ sender: UIButton) {
        if let dayView = UINib(nibName: "MonthView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            MonthView{
            setDayView(dayView : dayView)
        }
    }
    @IBAction func onYearClick(_ sender: UIButton) {
        if let dayView = UINib(nibName: "YearView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            YearView{
            setDayView(dayView : dayView)
        }
    }
    func setDayView(dayView: UIView){
        dynamicView.removeFromSuperview()
        dynamicView = dayView
        dynamicView.translatesAutoresizingMaskIntoConstraints = false
        dynamicView.frame = CGRect(x: 0, y: 0, width: dynamicView.frame.width, height: dynamicView.frame.height)
        self.addSubview(dynamicView)
        dynamicView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        dynamicView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        dynamicView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        dynamicView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

}
