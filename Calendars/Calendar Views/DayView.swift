//
//  DayView.swift
//  Calendars
//
//  Created by Rafin Rahman on 12/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class DayView: UIView, UIScrollViewDelegate {
    
    let startTime = CGFloat(2)
    let endTime = CGFloat(4)
    
    let startTime2 = CGFloat(3)
    let endTime2 = CGFloat(5)
    
    let startTime3 = CGFloat(2)
    let endTime3 = CGFloat(3)
    
    
    
    
    @IBOutlet weak var leftScroll: UIScrollView!
    @IBOutlet weak var rightScroll: UIScrollView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    
    
    func populateStackView() {
        
        
        let event = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        event.backgroundColor = .brown
        event.translatesAutoresizingMaskIntoConstraints = false
        rightScroll.addSubview(event)
        event.topAnchor.constraint(equalTo: rightScroll.topAnchor, constant: startTime * 60 ).isActive = true
        event.leadingAnchor.constraint(equalTo: rightScroll.leadingAnchor, constant: 0).isActive = true
        event.widthAnchor.constraint(equalToConstant: rightScroll.layer.bounds.width/2).isActive = true
        event.heightAnchor.constraint(equalToConstant: endTime * 60 ).isActive = true
        
        
        
        let eventTwo = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        eventTwo.backgroundColor = .blue
        eventTwo.translatesAutoresizingMaskIntoConstraints = false
        rightScroll.addSubview(eventTwo)
        eventTwo.topAnchor.constraint(equalTo: rightScroll.topAnchor, constant: startTime2 * 60 ).isActive = true
        eventTwo.leadingAnchor.constraint(equalTo: rightScroll.leadingAnchor, constant: rightScroll.frame.width/2).isActive = true
        eventTwo.trailingAnchor.constraint(equalTo: rightScroll.trailingAnchor, constant: 0).isActive = true
        eventTwo.widthAnchor.constraint(equalTo: rightScroll.widthAnchor).isActive = true
        eventTwo.heightAnchor.constraint(equalToConstant: endTime2 * 60).isActive = true
        
        
        
    }
    
    func checkClashingEvents(start:CGFloat, end:CGFloat, start2:CGFloat, end2:CGFloat) -> Int {
        var counter = 0
        
//        if(){
//            
//        }
        
        
        return counter
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           if scrollView == rightScroll {
               self.synchronizeScrollView(leftScroll, toScrollView: rightScroll)
           }
           else if scrollView == leftScroll {
               self.synchronizeScrollView(rightScroll, toScrollView: leftScroll)
           }
       }

       func synchronizeScrollView(_ scrollViewToScroll: UIScrollView, toScrollView scrolledView: UIScrollView) {
           var offset = scrollViewToScroll.contentOffset
           offset.y = scrolledView.contentOffset.y

           scrollViewToScroll.setContentOffset(offset, animated: false)
       }
    
   

}
