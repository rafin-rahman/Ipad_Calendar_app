//
//  BinView.swift
//  Calendars
//
//  Created by Rafin Rahman on 17/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class BinView: UIView, NavigationProtocol {

    @IBOutlet weak var leftStack: UIStackView!
    var dynamicView: CalendarProtocol!
    
   
    
    
    func onLoad() {
        showDeletedEvents()
    }
    

    func showDeletedEvents(){
        
        if let deletedEventView = UINib(nibName: "BinRowView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? BinRowView {
            deletedEventView.translatesAutoresizingMaskIntoConstraints = false
            leftStack.addArrangedSubview(deletedEventView)
            deletedEventView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            print("Oh shit")
        }
        
        
    }

}
