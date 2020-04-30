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
    
    var dynamicView: CalendarProtocol!
    
    func onLoad(){
        let eventDAO = EventDAO()
        eventDAO.getAllEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let listofEventsGroupedByDate = self.getEventsGroupedbyDate(eventList: eventDAO.eventList)
            self.showEventsAccordingToDate(eventList: listofEventsGroupedByDate)
            //let listofEventsGroupedByProfile = self.getEventsGroupedbyProfile(eventList: eventDAO.eventList)
            //print(listofEventsGroupedByProfile)
        }
    }
        
    func showEventsAccordingToDate(eventList:Dictionary<Date, Array<Event>>){
        let sortedDic = eventList.sorted { (firstDic, secondDic) -> Bool in
            return firstDic.key < secondDic.key
        }
        
        for (dateValue, listOfEvent) in sortedDic {
            let outerStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            outerStackView.alignment = .fill
            outerStackView.distribution = .equalSpacing
            outerStackView.axis = .vertical
              
            let dateView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            
            let dateLabel = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            dateLabel.text = dateValue.toString(dateFormat: "dd MMM YYYY")
            dateLabel.textColor = UIColor.gray // need to change this\
            dateLabel.font = UIFont.systemFont(ofSize: 25)
            dateLabel.numberOfLines = 0
            dateLabel.sizeToFit()
            
            outerStackView.translatesAutoresizingMaskIntoConstraints = false
            dateView.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            
            globalStack.addArrangedSubview(outerStackView)
            outerStackView.addArrangedSubview(dateView)
            dateView.addSubview(dateLabel)
            
            dateView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            dateView.backgroundColor = .yellow
            
            dateLabel.topAnchor.constraint(equalTo: dateView.topAnchor, constant: 20).isActive = true
            dateLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: 90).isActive = true
            dateLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
            
            
            for eventDetails in listOfEvent{
                let eventView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                eventView.backgroundColor = SelectColor.getColor(color: eventDetails.profileColour)
                
                let priorityView = UIView(frame: CGRect(x: 0, y:0, width:0, height: 0))
                priorityView.backgroundColor = PriorityColorSelector.getColor(priority: eventDetails.priority)
                
                let clockImgName = UIImage(named: "Clock")
                
                let clockView = UIImageView(image: clockImgName!)
                
                let timeLabel = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
                let startTime = eventDetails.startDate.stripDate().toString(dateFormat: "HH-mm")
                let endTime = eventDetails.endDate.stripDate().toString(dateFormat: "HH-mm")
                timeLabel.text = startTime! + " - " + endTime!
                timeLabel.textColor = UIColor.gray // need to change this\
                timeLabel.font = UIFont.systemFont(ofSize: 17)
                timeLabel.numberOfLines = 0
                timeLabel.sizeToFit()
                
                let eventNameLabel = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
                eventNameLabel.text = eventDetails.eventName
                eventNameLabel.textColor = UIColor.gray // need to change this\
                eventNameLabel.font = UIFont.boldSystemFont(ofSize: 22)
                eventNameLabel.numberOfLines = 0
                eventNameLabel.sizeToFit()
                
                let profileNameLabel = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
                profileNameLabel.text = eventDetails.profile
                profileNameLabel.textColor = UIColor.gray // need to change this\
                profileNameLabel.font = UIFont.systemFont(ofSize: 12)
                profileNameLabel.numberOfLines = 0
                profileNameLabel.sizeToFit()
                                
                eventView.translatesAutoresizingMaskIntoConstraints = false
                priorityView.translatesAutoresizingMaskIntoConstraints = false
                clockView.translatesAutoresizingMaskIntoConstraints = false
                timeLabel.translatesAutoresizingMaskIntoConstraints = false
                eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
                profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
                
                outerStackView.addArrangedSubview(eventView)
                eventView.addSubview(priorityView)
                eventView.addSubview(clockView)
                eventView.addSubview(timeLabel)
                eventView.addSubview(eventNameLabel)
                eventView.addSubview(profileNameLabel)

                eventView.heightAnchor.constraint(equalToConstant: 60).isActive = true
                
                priorityView.topAnchor.constraint(equalTo: eventView.topAnchor, constant: 0).isActive = true
                priorityView.leadingAnchor.constraint(equalTo: eventView.leadingAnchor, constant: 0).isActive = true
                priorityView.heightAnchor.constraint(equalTo: eventView.heightAnchor, multiplier: 1).isActive = true
                priorityView.widthAnchor.constraint(equalToConstant: 60).isActive = true
                                
                clockView.topAnchor.constraint(equalTo: eventView.topAnchor, constant: 20).isActive = true
                clockView.leadingAnchor.constraint(equalTo: priorityView.trailingAnchor, constant: 20).isActive = true
                clockView.heightAnchor.constraint(equalToConstant: 20).isActive = true
                clockView.widthAnchor.constraint(equalToConstant: 20).isActive = true
                
                timeLabel.topAnchor.constraint(equalTo: eventView.topAnchor,constant: 20).isActive = true
                timeLabel.leadingAnchor.constraint(equalTo: clockView.trailingAnchor, constant: 20).isActive = true
                
                eventNameLabel.topAnchor.constraint(equalTo: eventView.topAnchor,constant: 16).isActive = true
                eventNameLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 20).isActive = true
                
                profileNameLabel.topAnchor.constraint(equalTo: eventView.topAnchor,constant: 40).isActive = true
                profileNameLabel.trailingAnchor.constraint(equalTo: eventView.trailingAnchor, constant: -25).isActive = true
            }
            
              
        }
        
    }
        
    func getEventsGroupedbyDate(eventList : Array<Event>) -> Dictionary<Date, Array<Event>>{
        var eventDictonary : Dictionary <Date, Array<Event>> = Dictionary()
        for event in eventList{
            eventDictonary[event.startDate.stripTime(), default: []].append(event)
        }
       return eventDictonary
    }
    
    func getEventsGroupedbyProfile(eventList : Array<Event>) -> Dictionary<String, Array<Event>>{
        var eventDictonary : Dictionary <String, Array<Event>> = Dictionary()
        for event in eventList{
            eventDictonary[event.profile, default: []].append(event)
        }
        return eventDictonary
    }

}
