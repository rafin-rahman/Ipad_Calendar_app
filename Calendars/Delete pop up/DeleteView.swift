//
//  DeleteView.swift
//  Calendars
//
//  Created by Rafin Rahman on 26/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import Foundation
import UIKit

class DeleteView : UIView{
    
    @IBOutlet weak var messageContainerView: UIView!
    
    
    
    func onLoad() {
    messageContainerView.layer.cornerRadius = 10
    messageContainerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    messageContainerView.layer.shadowOffset = CGSize(width: 3.0, height: 5.0)
    messageContainerView.layer.shadowOpacity = 1
    messageContainerView.layer.shadowRadius = 3
    }
    @IBAction func cancelClick(_ sender: Any) {
      self.isHidden = true
    }
}
