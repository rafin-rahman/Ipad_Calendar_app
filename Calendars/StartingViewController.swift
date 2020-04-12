//
//  ViewController.swift
//  Calendars
//
//  Created by Rafin Rahman on 21/03/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class StartingViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var dynamicView: UIView!
    
    @IBOutlet weak var sidebarWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        onDayClick(nil)
    }
    
    @IBAction func sidebarButtonClick(_ sender: UIButton) {
        if sidebarWidthConstraint.constant == 0 {
            sidebarWidthConstraint.constant = 150
        } else {
            sidebarWidthConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    @IBAction func onDayClick(_ sender: Any?) {
        if let newView = UINib(nibName: "DayView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? DayView {
            setViewDetails(newView: newView)
        }
    }

    @IBAction func onWeekClick(_ sender: UIButton) {
        if let newView = UINib(nibName: "WeekView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? WeekView {
            setViewDetails(newView: newView)
        }
    }
    @IBAction func onMonthClick(_ sender: UIButton) {
        if let newView = UINib(nibName: "MonthView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? MonthView {
            setViewDetails(newView: newView)
        }
    }
    
    func setViewDetails(newView: UIView) {
        dynamicView.removeFromSuperview()
        dynamicView = newView
        dynamicView.translatesAutoresizingMaskIntoConstraints = false
        rightView.addSubview(dynamicView)
        dynamicView.frame = CGRect(x: 0, y: 0, width: rightView.frame.width, height: 300)
        dynamicView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        dynamicView.bottomAnchor.constraint(equalTo: rightView.bottomAnchor).isActive = true
        dynamicView.leadingAnchor.constraint(equalTo: rightView.leadingAnchor).isActive = true
        dynamicView.trailingAnchor.constraint(equalTo: rightView.trailingAnchor).isActive = true
    }

}

