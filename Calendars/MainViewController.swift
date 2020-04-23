//
//  ViewController.swift
//  Calendars
//
//  Created by Rafin Rahman on 21/03/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    
    
    
    // nagivation buttons
    @IBOutlet weak var homeNavButton: UIButton!
    @IBOutlet weak var eventNavButton: UIButton!
    @IBOutlet weak var taskNavButton: UIButton!
    @IBOutlet weak var binNavButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    // nagivation labels
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var binLabel: UILabel!
    
    
    // add, edit, task button constraint
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var eventButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var eventButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var eventButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var eventButtonBottom: NSLayoutConstraint!
    
    @IBOutlet weak var taskButton: UIButton!
    @IBOutlet weak var taskButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var taskButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var taskButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var taskButtonBottom: NSLayoutConstraint!
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var sidebarWidthConstraint: NSLayoutConstraint!
    
    var addButtonStatus = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onHomeClick(nil)
        addButtonStyle()
        
    }
       
    
    @IBAction func hideSidebar(_ sender: UISwipeGestureRecognizer) {
        if sidebarWidthConstraint.constant == 0 {
            sidebarWidthConstraint.constant = 150
        } else {
            sidebarWidthConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEditSegueEvent" {
            if let destinationVC = segue.destination as? AddEditViewController {
                destinationVC.isTask = false
                
                
            }
        } else if segue.identifier == "AddEditSegueTask" {
            if let destinationVC = segue.destination as? AddEditViewController {
                destinationVC.isTask = true
            }
        }
    }
    
    
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
            newRightView.onLoad()
            setRightViewDetails(newRightView: newRightView)
        }
        
        homeNavButton.alpha = 1
        eventNavButton.alpha = 0.4
        taskNavButton.alpha = 0.4
        binNavButton.alpha = 0.4
        
        homeLabel.alpha = 1
        eventLabel.alpha = 0.4
        taskLabel.alpha = 0.4
        binLabel.alpha = 0.4
        
        
    }
    
    
    @IBAction func onEventClick(_ sender: UIButton) {
        
        if let newRightView = UINib(nibName: "EventView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            EventView {
            setRightViewDetails(newRightView: newRightView)
        }
        homeNavButton.alpha = 0.4
        eventNavButton.alpha = 1
        taskNavButton.alpha = 0.4
        binNavButton.alpha = 0.4
        
        homeLabel.alpha = 0.4
        eventLabel.alpha = 1
        taskLabel.alpha = 0.4
        binLabel.alpha = 0.4
        
    }
    
    
    @IBAction func onTaskClick(_ sender: UIButton) {
        if let newRightView = UINib(nibName: "TaskView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            TaskView {
            setRightViewDetails(newRightView: newRightView)
        }
        homeNavButton.alpha = 0.4
        eventNavButton.alpha = 0.4
        taskNavButton.alpha = 1
        binNavButton.alpha = 0.4
        
        homeLabel.alpha = 0.4
        eventLabel.alpha = 0.4
        taskLabel.alpha = 1
        binLabel.alpha = 0.4
    }
    
    @IBAction func onBinClick(_ sender: UIButton) {
        if let newRightView = UINib(nibName: "BinView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            BinView {
            setRightViewDetails(newRightView: newRightView)
        }
        homeNavButton.alpha = 0.4
        eventNavButton.alpha = 0.4
        taskNavButton.alpha = 0.4
        binNavButton.alpha = 1
        
        homeLabel.alpha = 0.4
        eventLabel.alpha = 0.4
        taskLabel.alpha = 0.4
        binLabel.alpha = 1
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
        self.view.bringSubviewToFront(eventButton)
        self.view.bringSubviewToFront(taskButton)
        self.view.bringSubviewToFront(addButton)
        self.view.bringSubviewToFront(menuButton)
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
        if(addButtonStatus == false){
            
            taskButton.isHidden = false
            eventButton.isHidden = false
            
            eventButtonWidth.constant = 80
            eventButtonHeight.constant = 80
            eventButtonTrailing.constant = 40
            eventButtonBottom.constant = 30
            
            taskButtonWidth.constant = 80
            taskButtonHeight.constant = 80
            taskButtonTrailing.constant = 40
            taskButtonBottom.constant = -300
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.addButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
            }
            
            addButtonStatus = true
        }
        else {
            
            addButtonClosingAnimation()
        }
    }
    
    func addButtonClosingAnimation(){
        eventButtonWidth.constant = 1
        eventButtonHeight.constant = 1
        eventButtonTrailing.constant = 80
        eventButtonBottom .constant = 0
        
        taskButtonWidth.constant = 1
        taskButtonHeight.constant = 1
        taskButtonTrailing.constant = 80
        taskButtonBottom.constant = -30
        
        UIView.animate(withDuration: 0.5, animations:  {
            self.addButton.transform = .identity
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.eventButton.isHidden = true
            self.taskButton.isHidden = true
        })
        
        addButtonStatus = false
    }
    
    @IBAction func addEventClick(_ sender: UIButton) {
        if(addButtonStatus == true){
            addButtonClosingAnimation()
            
        }
    }
    
    @IBAction func addTaskClick(_ sender: UIButton) {
        
        if(addButtonStatus == true){
            addButtonClosingAnimation()
            
        }
        
    }
    
   
    
    @IBAction func menuButtonClick(_ sender: UIButton) {
        
    }
}

