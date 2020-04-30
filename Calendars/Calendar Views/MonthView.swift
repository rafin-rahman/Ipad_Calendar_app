//
//  MonthVIew.swift
//  Calendars
//
//  Created by Rafin Rahman on 12/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class MonthView: UIView, CalendarProtocol {
    
    @IBOutlet weak var weekOneStack: UIStackView!
    @IBOutlet weak var cellOneView: UIView!
    @IBOutlet weak var oneView: UIView!
    
    
    
    func loadData() {
        for subview in weekOneStack.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        for i in 1...7 {
            if let newView = UINib(nibName: "MonthCellView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? MonthCellView {
                weekOneStack.addArrangedSubview(newView)
            }
        }
    }
  
    func showMonthCell(){
        
    }

}
