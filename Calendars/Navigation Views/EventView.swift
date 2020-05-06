//
//  EventViewController.swift
//  Calendars
//
//  Created by Rafin Rahman on 16/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit



class EventView: UIView, NavigationProtocol {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var globalStack: UIStackView!
    @IBOutlet weak var menuEvent: UIView!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var folderButton: UIButton!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    var dynamicView: CalendarProtocol!
    
    var activeEventView: TempConstraintView!
    
    var orderByTime = true
    
    func onLoad(){
        globalStack.removeAllArrangedSubviews()
        if orderByTime{
             self.listButton.tintColor = .systemBlue
        }
        let eventDAO = EventDAO()
        eventDAO.getAllEventsForCurrentDay()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.orderByTime == true{
                let listofEventsGroupedByDate = self.getEventsGroupedbyDate(eventList: eventDAO.eventList)
                self.showEventsAccordingToDate(eventList: listofEventsGroupedByDate)
            } else {
                let listofEventsGroupedByProfile = self.getEventsGroupedbyProfile(eventList: eventDAO.eventList)
                self.showEventsAccordingToProfile(eventList: listofEventsGroupedByProfile)
            }
        }
    }
    
    func showEventsAccordingToDate(eventList:Dictionary<Date, Array<Events>>){
        let blankEvent = TempConstraintView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        blankEvent.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "EFF2F5", alpha: 1)
        blankEvent.translatesAutoresizingMaskIntoConstraints = false
        let sortedDic = eventList.sorted { (firstDic, secondDic) -> Bool in
            return firstDic.key < secondDic.key
        }
        for (dateValue, listOfEvent) in sortedDic {
            let innerStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            innerStackView.alignment = .fill
            innerStackView.distribution = .equalSpacing
            innerStackView.axis = .vertical
            innerStackView.spacing = 2
            
            let dateView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            dateView.tag = 1
            
            let dateLabel = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            dateLabel.text = dateValue.toString(dateFormat: "dd MMM YYYY")
            dateLabel.textColor = HexToUIColor.hexStringToUIColor(hex: "444444", alpha: 1)
            dateLabel.font = UIFont.systemFont(ofSize: 25)
            dateLabel.numberOfLines = 0
            dateLabel.sizeToFit()
            
            //Collapsable
            let collapseButton: InfoButton = InfoButton(type: .custom)
            collapseButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            let collapseIcon = UIImage(named: "Collapse Icon") as UIImage?
            collapseButton.setImage(collapseIcon, for: .normal)
            collapseButton.selectedButton = collapseButton
            collapseButton.addTarget(self, action: #selector(collapsableButton(_:)), for: .touchUpInside)
            
            
            innerStackView.translatesAutoresizingMaskIntoConstraints = false
            dateView.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            collapseButton.translatesAutoresizingMaskIntoConstraints = false
            
            
            globalStack.addArrangedSubview(innerStackView)
            innerStackView.addArrangedSubview(dateView)
            dateView.addSubview(dateLabel)
            dateView.addSubview(collapseButton)
            
            dateView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            dateView.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.96, alpha: 1.00)
            
            dateLabel.topAnchor.constraint(equalTo: dateView.topAnchor, constant: 20).isActive = true
            dateLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: 70).isActive = true
            dateLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
            
            collapseButton.trailingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: -50).isActive = true
            collapseButton.centerYAnchor.constraint(equalTo: dateView.centerYAnchor, constant: 10).isActive = true
            collapseButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            collapseButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            setDetailsOfEvents(listOfEvent: listOfEvent, innerStackView: innerStackView, collapsable: collapseButton)
            
            
        }
        globalStack.addArrangedSubview(blankEvent)
        blankEvent.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func showEventsAccordingToProfile(eventList:Dictionary<String, Array<Events>>){
        let blankEvent = TempConstraintView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        blankEvent.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "EFF2F5", alpha: 1)
        blankEvent.translatesAutoresizingMaskIntoConstraints = false
        
        let sortedDic = eventList.sorted { (firstDic, secondDic) -> Bool in
            return firstDic.key < secondDic.key
        }
        
        for (profile, listOfEvent) in sortedDic {
            let innerStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            innerStackView.alignment = .fill
            innerStackView.distribution = .equalSpacing
            innerStackView.axis = .vertical
            innerStackView.spacing = 2
            
            let dateView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            
            dateView.tag = 1
            
            let dateLabel = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            dateLabel.text = profile
            dateLabel.textColor = HexToUIColor.hexStringToUIColor(hex: "444444", alpha: 1)
            dateLabel.font = UIFont.systemFont(ofSize: 25)
            dateLabel.numberOfLines = 0
            dateLabel.sizeToFit()
            
            let collapseButton: InfoButton = InfoButton(type: .custom)
            collapseButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            let collapseIcon = UIImage(named: "Collapse Icon") as UIImage?
            collapseButton.setImage(collapseIcon, for: .normal)
            collapseButton.selectedButton = collapseButton
            collapseButton.addTarget(self, action: #selector(collapsableButton(_:)), for: .touchUpInside)
            
            
            innerStackView.translatesAutoresizingMaskIntoConstraints = false
            dateView.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            collapseButton.translatesAutoresizingMaskIntoConstraints = false
            
            
            globalStack.addArrangedSubview(innerStackView)
            innerStackView.addArrangedSubview(dateView)
            dateView.addSubview(dateLabel)
            dateView.addSubview(collapseButton)
            
            dateView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            dateView.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.96, alpha: 1.00)
            
            dateLabel.topAnchor.constraint(equalTo: dateView.topAnchor, constant: 20).isActive = true
            dateLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: 70).isActive = true
            dateLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
            
            collapseButton.trailingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: -50).isActive = true
            collapseButton.centerYAnchor.constraint(equalTo: dateView.centerYAnchor, constant: 10).isActive = true
            collapseButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            collapseButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            setDetailsOfEvents(listOfEvent: listOfEvent, innerStackView: innerStackView, collapsable: collapseButton)
            
            
        }
        globalStack.addArrangedSubview(blankEvent)
        blankEvent.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setDetailsOfEvents(listOfEvent:Array<Events>, innerStackView:UIStackView, collapsable:InfoButton){
        for eventDetails in listOfEvent{
                        
            let eventView = TempConstraintView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            eventView.backgroundColor = SelectColor.getColor(color: eventDetails.profileColour)
            
            let optionView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            optionView.backgroundColor = .purple
            optionView.clipsToBounds = true
            
            let editView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            editView.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "fd9644", alpha: 1)
            let binView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            binView.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "#c0392b", alpha: 1)
            
            let editButton: InfoButton = InfoButton(type: .custom)
            editButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            let editIcon = UIImage(named: "Edit icon") as UIImage?
            editButton.translatesAutoresizingMaskIntoConstraints = false
            editButton.setImage(editIcon, for: .normal)
            editButton.eventDetail = eventDetails
            editButton.addTarget(self, action: #selector(editButtonClick(_:)), for: .touchUpInside)
            
            let binButton:InfoButton = InfoButton(type: .custom)
            binButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            let binIcon = UIImage(named: "Bin button") as UIImage?
            binButton.translatesAutoresizingMaskIntoConstraints = false
            binButton.setImage(binIcon, for: .normal)
            binButton.eventDetail = eventDetails
            binButton.addTarget(self, action: #selector(deleteButtonClick(_:)), for: .touchUpInside)
            
            let priorityView = UIView(frame: CGRect(x: 0, y:0, width:0, height: 0))
            priorityView.backgroundColor = PriorityColorSelector.getColor(priority: eventDetails.priority)
            
            let clockImgName = UIImage(named: "Clock")
            
            let clockView = UIImageView(image: clockImgName!)
            
            let timeLabel = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            
            if eventDetails.allDay{
                timeLabel.text = "All Day"
            }
            else{
                let startTime = eventDetails.startDate.stripDate().toString(dateFormat: "HH:mm")
                let endTime = eventDetails.endDate.stripDate().toString(dateFormat: "HH:mm")
                timeLabel.text = startTime! + " - " + endTime!
            }
            
            timeLabel.textColor = .white
            timeLabel.font = UIFont.systemFont(ofSize: 17)
            timeLabel.numberOfLines = 0
            timeLabel.sizeToFit()
            
            let eventNameLabel = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            eventNameLabel.text = eventDetails.eventName
            eventNameLabel.textColor = .white
            eventNameLabel.font = UIFont.boldSystemFont(ofSize: 22)
            eventNameLabel.numberOfLines = 0
            eventNameLabel.sizeToFit()
            
            let profileNameLabel = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            profileNameLabel.text = eventDetails.profile
            profileNameLabel.textColor = .white
            profileNameLabel.font = UIFont.systemFont(ofSize: 12)
            profileNameLabel.numberOfLines = 0
            profileNameLabel.sizeToFit()
            
            eventView.translatesAutoresizingMaskIntoConstraints = false
            optionView.translatesAutoresizingMaskIntoConstraints = false
            editView.translatesAutoresizingMaskIntoConstraints = false
            binView.translatesAutoresizingMaskIntoConstraints = false
            priorityView.translatesAutoresizingMaskIntoConstraints = false
            clockView.translatesAutoresizingMaskIntoConstraints = false
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
            profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
            
            innerStackView.addArrangedSubview(eventView)
            eventView.addSubview(priorityView)
            eventView.addSubview(clockView)
            eventView.addSubview(timeLabel)
            eventView.addSubview(eventNameLabel)
            eventView.addSubview(profileNameLabel)
            eventView.addSubview(optionView)
            optionView.addSubview(editView)
            optionView.addSubview(binView)
            editView.addSubview(editButton)
            binView.addSubview(binButton)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(_:)))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            eventView.addGestureRecognizer(swipeLeft)
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(_:)))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            eventView.addGestureRecognizer(swipeRight)
            
            eventView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            priorityView.topAnchor.constraint(equalTo: eventView.topAnchor, constant: 0).isActive = true
            priorityView.leadingAnchor.constraint(equalTo: eventView.leadingAnchor, constant: 0).isActive = true
            priorityView.heightAnchor.constraint(equalTo: eventView.heightAnchor, multiplier: 1).isActive = true
            priorityView.widthAnchor.constraint(equalToConstant: 60).isActive = true
            
            optionView.centerYAnchor.constraint(equalTo: eventView.centerYAnchor).isActive = true
            optionView.trailingAnchor.constraint(equalTo: eventView.trailingAnchor, constant: 0).isActive = true
            optionView.heightAnchor.constraint(equalTo: eventView.heightAnchor, multiplier: 1).isActive = true
            eventView.optionViewConstraint = optionView.widthAnchor.constraint(equalToConstant: 0)
            eventView.optionViewConstraint.isActive = true
            
            editView.centerYAnchor.constraint(equalTo: optionView.centerYAnchor).isActive = true
            editView.leadingAnchor.constraint(equalTo: optionView.leadingAnchor, constant: 0).isActive = true
            editView.heightAnchor.constraint(equalTo: optionView.heightAnchor, multiplier: 1).isActive = true
            editView.widthAnchor.constraint(equalTo: optionView.widthAnchor, multiplier: 0.5, constant: 0).isActive = true
            
            binView.centerYAnchor.constraint(equalTo: optionView.centerYAnchor).isActive = true
            binView.trailingAnchor.constraint(equalTo: optionView.trailingAnchor, constant: 0).isActive = true
            binView.heightAnchor.constraint(equalTo: optionView.heightAnchor, multiplier: 1).isActive = true
            binView.widthAnchor.constraint(equalTo: optionView.widthAnchor, multiplier: 0.5, constant: 0).isActive = true
            
            editButton.centerYAnchor.constraint(equalTo: editView.centerYAnchor).isActive = true
            editButton.centerXAnchor.constraint(equalTo: editView.centerXAnchor).isActive = true
            editButton.heightAnchor.constraint(equalTo: editView.heightAnchor, multiplier: 1).isActive = true
            editButton.widthAnchor.constraint(equalTo: editView.widthAnchor, multiplier: 1).isActive = true
            editButton.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            
            
            binButton.centerYAnchor.constraint(equalTo: binView.centerYAnchor).isActive = true
            binButton.centerXAnchor.constraint(equalTo: binView.centerXAnchor).isActive = true
            binButton.heightAnchor.constraint(equalTo: binView.heightAnchor, multiplier: 1).isActive = true
            binButton.widthAnchor.constraint(equalTo: binView.widthAnchor, multiplier: 1).isActive = true
            binButton.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            
            clockView.topAnchor.constraint(equalTo: eventView.topAnchor, constant: 20).isActive = true
            clockView.leadingAnchor.constraint(equalTo: priorityView.trailingAnchor, constant: 20).isActive = true
            clockView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            clockView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            timeLabel.topAnchor.constraint(equalTo: eventView.topAnchor,constant: 20).isActive = true
            timeLabel.leadingAnchor.constraint(equalTo: clockView.trailingAnchor, constant: 20).isActive = true
            
            eventNameLabel.topAnchor.constraint(equalTo: eventView.topAnchor,constant: 16).isActive = true
            eventNameLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 20).isActive = true
            
            profileNameLabel.topAnchor.constraint(equalTo: eventView.topAnchor,constant: 40).isActive = true
            profileNameLabel.trailingAnchor.constraint(equalTo: optionView.leadingAnchor, constant: -50).isActive = true
            
            
            collapsable.addTarget(self, action: #selector(collapsableButton(_:)), for: .touchUpInside)
        }
    }
    
    @objc func swipeLeft(_ sender: UIGestureRecognizer) {
        if let eventView = sender.view as? TempConstraintView {
            if activeEventView != nil && activeEventView != eventView{
                closeView(activeEventView)
            }
            activeEventView = eventView
            openView(eventView)
        }
    }
    
    @objc func swipeRight(_ sender: UIGestureRecognizer) {
        if let eventView = sender.view as? TempConstraintView {
            closeView(eventView)
            activeEventView = nil
        }
    }
    
    func openView(_ eventView: TempConstraintView) {
        eventView.optionViewConstraint.constant = 120
        UIView.animate(withDuration: 0.2, animations: {
            eventView.layoutIfNeeded()
        })
    }
    
    func closeView(_ eventView: TempConstraintView) {
        eventView.optionViewConstraint.constant = 0
        UIView.animate(withDuration: 0.2, animations: {
            eventView.layoutIfNeeded()
        })
    }
    
    func getEventsGroupedbyDate(eventList : Array<Events>) -> Dictionary<Date, Array<Events>>{
        var eventDictonary : Dictionary <Date, Array<Events>> = Dictionary()
        let sortedList = eventList.sorted {
            $0.startDate < $1.startDate
        }
        for event in sortedList{
            eventDictonary[event.startDate.stripTime(), default: []].append(event)
        }
        return eventDictonary
    }
    
    func getEventsGroupedbyProfile(eventList : Array<Events>) -> Dictionary<String, Array<Events>>{
        var eventDictonary : Dictionary <String, Array<Events>> = Dictionary()
        for event in eventList{
            eventDictonary[event.profile, default: []].append(event)
        }
        return eventDictonary
    }
    
    
    @IBAction func groupByProfileClick(_ sender: UIButton) {
        subTitleLabel.text = "Sorted by profile"
        self.folderButton.tintColor = .systemBlue
        self.listButton.tintColor = HexToUIColor.hexStringToUIColor(hex: "747474", alpha: 1)
        orderByTime = false
        onLoad()
    }
    
    @IBAction func groupByTimeClick(_ sender: UIButton) {
        subTitleLabel.text = "Sorted by date"
        self.listButton.tintColor = .systemBlue
        self.folderButton.tintColor = HexToUIColor.hexStringToUIColor(hex: "747474", alpha: 1)
        orderByTime = true
        onLoad()
    }
    
    @objc func editButtonClick(_ sender:InfoButton){
        if let viewController = getOwningViewController() as? MainViewController {
            let popoverContent = viewController.storyboard!.instantiateViewController(withIdentifier: "AddEditViewController") as! AddEditViewController
            popoverContent.modalPresentationStyle = .overCurrentContext
            popoverContent.modalTransitionStyle = .crossDissolve
            viewController.present(popoverContent, animated: true, completion: nil)
            popoverContent.eventEditDetails(event: sender.eventDetail!)
            popoverContent.onDismiss = onSegDismiss
        }
    }
    
    func onSegDismiss() {
        onLoad()
    }
    
    @objc func deleteButtonClick(_ sender: InfoButton) {
        if let viewController = self.getOwningViewController() as? MainViewController {
            let refreshAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this event?", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                EventDAO().editDeleteStatus(id: sender.eventDetail!.id, deleteStatus:true)
                self.onLoad()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            viewController.present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    @objc func collapsableButton(_ sender:InfoButton){
           if let stackView = sender.superview?.superview as? UIStackView {
               if stackView.tag == -1 {
                   
                   UIView.animate(withDuration: 0.5, animations:  {
                       
                       for subview in stackView.arrangedSubviews {
                           if subview.tag != 1 {
                               UIView.animate(withDuration: 0.3, animations: {
                                   subview.isHidden = false
                               })
                           }
                       }
                       stackView.tag = 1
                       sender.selectedButton!.imageView!.transform = .identity
                       self.layoutIfNeeded()
                   }, completion: nil)
               } else {
                   UIView.animate(withDuration: 0.5, animations:  {
                       for subview in stackView.arrangedSubviews {
                           if subview.tag != 1 {
                               UIView.animate(withDuration: 0.3, animations: {
                                   subview.isHidden = true
                               })
                           }
                       }
                       stackView.tag = -1
                       sender.selectedButton!.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                       self.layoutIfNeeded()
                   }, completion: nil)
               }
               stackView.layoutIfNeeded()
           }
           
           
       }
}
