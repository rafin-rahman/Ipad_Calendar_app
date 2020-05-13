//
//  LoginViewController.swift
//  Calendars
//
//  Created by Rafin Rahman on 11/05/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var welcomelabel: UILabel!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    
    
    var  number = CGFloat(0)
    override func viewDidLoad() {
        super.viewDidLoad()

        formStyle()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            if UIDevice.current.orientation.isLandscape {
                self.number = -200
            } else {
                self.number = -500
            }
        })
    } 
     
    func formStyle(){
        
        logoImage.layer.shadowOpacity = 1
        welcomelabel.layer.shadowOpacity = 0.2
    }
    
    @IBAction func testClick(_ sender: UIButton) {
      
        topSpace.constant = number
        //topSpace.constant = -600
        
    }
    
    
    

}
