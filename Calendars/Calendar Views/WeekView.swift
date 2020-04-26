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
    
    func loadData() {
        
    }
    @IBOutlet weak var rightScroll: UIScrollView!
    @IBOutlet weak var leftScroll: UIScrollView!
    
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
}


