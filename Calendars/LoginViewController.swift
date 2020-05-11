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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formStyle()
    }
    
    func formStyle(){
        
        logoImage.layer.shadowOpacity = 1
        welcomelabel.layer.shadowOpacity = 0.2
    }


}
