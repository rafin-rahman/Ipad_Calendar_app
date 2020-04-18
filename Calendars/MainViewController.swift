//
//  ViewController.swift
//  Calendars
//
//  Created by Rafin Rahman on 21/03/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var sidebarWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        onHomeClick(nil)
    }
    
    @IBAction func HideSidebar(_ sender: UISwipeGestureRecognizer) {
        
        if sidebarWidthConstraint.constant == 0 {
            sidebarWidthConstraint.constant = 150
        } else {
            sidebarWidthConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
   // TO FIX
    @IBAction func showSidebar(_ sender: UIScreenEdgePanGestureRecognizer) {
        
        if sidebarWidthConstraint.constant == 0 {
                  sidebarWidthConstraint.constant = 150
              } else {
                  sidebarWidthConstraint.constant = 0
              }
              
              UIView.animate(withDuration: 0.2, animations: {
                  self.view.layoutIfNeeded()
              })
    }
    
    
    @IBAction func onHomeClick(_ sender: Any?) {
        if let newRightView = UINib(nibName: "HomeView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
        HomeView {
        setRightViewDetails(newRightView: newRightView)
            newRightView.onLoad()
        }
    }
    
    
    @IBAction func onEventClick(_ sender: UIButton) {
        
        if let newRightView = UINib(nibName: "EventView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
        EventView {
        setRightViewDetails(newRightView: newRightView)
        }
    }
    

    @IBAction func onTaskClick(_ sender: UIButton) {
        if let newRightView = UINib(nibName: "TaskView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
        TaskView {
        setRightViewDetails(newRightView: newRightView)
        }

    }
    @IBAction func onBinClick(_ sender: UIButton) {
        if let newRightView = UINib(nibName: "BinView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
        BinView {
        setRightViewDetails(newRightView: newRightView)
        }
    }
    
    func setRightViewDetails(newRightView: UIView){
        rightView.removeFromSuperview()
        rightView = newRightView
        rightView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(newRightView)
        rightView.frame = CGRect(x: 0, y: 0, width: rightView.frame.width, height: 1004)
        rightView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rightView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        rightView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor).isActive = true
        rightView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }

}

