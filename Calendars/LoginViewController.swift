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
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
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
    
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        TextfieldAnimation.convertToNormal(textField: emailField)
        TextfieldAnimation.convertToNormal(textField: passwordField)
                
        let email = emailField.text
        // text validation
        if email == "" {
            TextfieldAnimation.errorAnimation(textField: emailField)
            return
        }

        let password = passwordField.text
        if password == ""{
            TextfieldAnimation.errorAnimation(textField: passwordField)
            return
        }
        
        let userDAO = UserDAO()
        userDAO.validateUser(email: email!, password: password!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if userDAO.user != nil{
                UserSession.userDetails = userDAO.user
            
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                
                guard let viewController = 	mainStoryBoard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else{
                    print("Couldn't load")
                    return
                }
                
                viewController.modalPresentationStyle = .fullScreen
                viewController.modalTransitionStyle = .crossDissolve
                self.present(viewController, animated: true, completion: nil)
                
            }
        }
        
    }
    
    

}	
