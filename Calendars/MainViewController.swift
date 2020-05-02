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
    @IBOutlet weak var profileNavButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    
    // nagivation labels
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var binLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    
    
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
    
    var rightView: NavigationProtocol!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var searchViewTop: UIView!
    
    @IBOutlet weak var sidebarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightViewTrailingToSafeArea: NSLayoutConstraint!
    
    var addButtonStatus = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onHomeClick(nil)
        addButtonStyle()
        
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
    
    func onSegDismiss() {
        if let home = self.rightView as? HomeView {
            home.dynamicView.loadData()
        }
        
        if let event = self.rightView as? EventView{
           event.onLoad()
        }
        //Add for OtherViews
    }
    
    //Add Or Edit View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? AddEditViewController {
            viewController.onDismiss = onSegDismiss
            if segue.identifier == "AddEditSegueEvent" {
                    viewController.isTask = false
                    if let home = self.rightView as? HomeView {
                        if let day = home.dynamicView as? DayView {
                            viewController.activeDate = day.activeDate
                        }
                    }
            } else if segue.identifier == "AddEditSegueTask" {
                viewController.isTask = true
            }
        }
    }
    
    
    func selectedButtonEffect(selectedButton : UIButton, selectedLabel : UILabel){
        homeNavButton.alpha = 0.4
        eventNavButton.alpha = 0.4
        taskNavButton.alpha = 0.4
        binNavButton.alpha = 0.4
        profileNavButton.alpha = 0.4
        
        homeLabel.alpha = 0.4
        eventLabel.alpha = 0.4
        taskLabel.alpha = 0.4
        binLabel.alpha = 0.4
        profileLabel.alpha = 0.4
        
        selectedButton.alpha = 1
        selectedLabel.alpha = 1
    }
    
    @IBAction func onHomeClick(_ sender: Any?) {
        
        if let newRightView = UINib(nibName: "HomeView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            HomeView {
            addButton.isHidden = false
            newRightView.onLoad()
            setRightViewDetails(newRightView: newRightView)
        }
        selectedButtonEffect(selectedButton: homeNavButton, selectedLabel: homeLabel)
        
        self.homeNavButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                         self.homeNavButton.transform = CGAffineTransform.identity
        },
                       completion: nil
        )
    }
    
    
    @IBAction func onEventClick(_ sender: UIButton) {
        
        if let newRightView = UINib(nibName: "EventView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            EventView {
            addButton.isHidden = false
            newRightView.onLoad()
            setRightViewDetails(newRightView: newRightView)
        }
        selectedButtonEffect(selectedButton: eventNavButton, selectedLabel: eventLabel)
        
        sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                         sender.transform = CGAffineTransform.identity
        },
                       completion: nil
        )
    }
    
    @IBAction func onTaskClick(_ sender: UIButton) {
        if let newRightView = UINib(nibName: "TaskView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            TaskView {
            addButton.isHidden = false
            setRightViewDetails(newRightView: newRightView)
        }
        selectedButtonEffect(selectedButton: taskNavButton, selectedLabel: taskLabel)
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                         sender.transform = CGAffineTransform.identity
        },
                       completion: nil
        )
    }
    
    @IBAction func onBinClick(_ sender: UIButton) {
        if let newRightView = UINib(nibName: "BinView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            BinView {
            addButton.isHidden = false
            setRightViewDetails(newRightView: newRightView)
            newRightView.onLoad()
            
        }
        selectedButtonEffect(selectedButton: binNavButton, selectedLabel: binLabel)
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                         sender.transform = CGAffineTransform.identity
        },
                       completion: nil
        )
    }
    
    @IBAction func profileButtonClick(_ sender: UIButton) {
        if let newRightView = UINib(nibName: "ProfileView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            ProfileView {
            addButton.isHidden = true
            newRightView.onLoad()
            setRightViewDetails(newRightView: newRightView)
        }
        selectedButtonEffect(selectedButton: profileNavButton, selectedLabel: profileLabel)
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                         sender.transform = CGAffineTransform.identity
        },
                       completion: nil
        )
    }
    
    func setRightViewDetails(newRightView: NavigationProtocol){
        if rightView != nil {
            rightView.removeFromSuperview()
        }
        rightView = newRightView
        rightView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(newRightView)
        rightView.frame = CGRect(x: 0, y: 0, width: rightView.frame.width, height: 1004)
        rightView.topAnchor.constraint(equalTo: searchViewTop.bottomAnchor).isActive = true
        rightView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        rightView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor).isActive = true
        rightViewTrailingToSafeArea = rightView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        rightViewTrailingToSafeArea.isActive = true
        self.view.bringSubviewToFront(eventButton)
        self.view.bringSubviewToFront(taskButton)
        self.view.bringSubviewToFront(addButton)
        
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
    
    
    @IBAction func menuClick(_ sender: UIButton) {
        if sidebarWidthConstraint.constant == 0 {
            sidebarWidthConstraint.constant = 150
            menuButton.alpha = 0.1
        } else {
            sidebarWidthConstraint.constant = 0
            menuButton.alpha = 1
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.view.layoutIfNeeded()
        })
    }
    
}

