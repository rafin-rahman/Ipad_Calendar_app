//
//  BinView.swift
//  Calendars
//
//  Created by Rafin Rahman on 17/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class BinView: UIView, NavigationProtocol, UIGestureRecognizerDelegate {

    @IBOutlet weak var leftStack: UIStackView!
    var dynamicView: CalendarProtocol!
    
    func onLoad() {
        let eventDAO = EventDAO()
        eventDAO.getAllDeletedEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showDeletedEvents(deletedEventList: eventDAO.eventList)
        }
    }
    

    func showDeletedEvents(deletedEventList : Array<Events>){
        print(deletedEventList.count)
        for deletedEvent in deletedEventList{
            if let deletedEventView = UINib(nibName: "BinRowView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? BinRowView {
                deletedEventView.translatesAutoresizingMaskIntoConstraints = false
                leftStack.addArrangedSubview(deletedEventView)
                deletedEventView.selectedEvent = deletedEvent
                deletedEventView.setDetails()
                deletedEventView.heightAnchor.constraint(equalToConstant: 60).isActive = true
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
                singleTap.delegate = self
                deletedEventView.addGestureRecognizer(singleTap)
            }
        }
        
    }
    
    @objc func onTap(_ sender : UITapGestureRecognizer) {
        if let event = sender.view as? BinRowView {
            let optionAlert = UIAlertController(title: "Options...", message: "Choose please", preferredStyle: .alert)
            
            optionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                // do nothing
            }))
            
            optionAlert.addAction(UIAlertAction(title: "Restore", style: .default, handler: { (action: UIAlertAction) in
                EventDAO().editDeleteStatus(id: event.selectedEvent.id, deleteStatus: false)
                self.leftStack.removeAllArrangedSubviews()
                self.onLoad()
            }))
            
            optionAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction) in
                EventDAO().deleteEvent(eventId: event.selectedEvent.id)
                self.leftStack.removeAllArrangedSubviews()
                self.onLoad()
            }))
            
            if let viewController = getOwningViewController() as? MainViewController {
                viewController.present(optionAlert, animated: true, completion: nil)
            }
        }
    }
}
