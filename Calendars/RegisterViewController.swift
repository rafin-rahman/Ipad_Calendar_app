//
//  RegisterViewController.swift
//  Calendars
//
//  Created by Rafin Rahman on 13/05/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordOneField: UITextField!
    @IBOutlet weak var passwordTwoField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerButtonClick(_ sender: UIButton) {
        TextfieldAnimation.convertToNormal(textField: emailField)
        TextfieldAnimation.convertToNormal(textField: passwordOneField)
        TextfieldAnimation.convertToNormal(textField: passwordTwoField)
                
        let email = emailField.text
        // text validation
        if email == "" {
            TextfieldAnimation.errorAnimation(textField: emailField)
            return
        }
        
        if email?.isValidEmail ?? false == false{
            TextfieldAnimation.errorAnimation(textField: emailField)
            return
        }

        let password = passwordOneField.text
        if password == ""{
            TextfieldAnimation.errorAnimation(textField: passwordOneField)
            return
        }
        
        let confirmPassword = passwordTwoField.text
        if confirmPassword == ""{
            TextfieldAnimation.errorAnimation(textField: passwordTwoField)
            return
        }
        
        if password != confirmPassword{
            TextfieldAnimation.errorAnimation(textField: passwordOneField)
            TextfieldAnimation.errorAnimation(textField: passwordTwoField)
            return
        }
        
        let userDAO = UserDAO()
        userDAO.getAllUser(email: email!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if userDAO.user == nil{
                let userDict: [String: Any] = [
                    "Email" : email!,
                    "Password" : confirmPassword!
                ]
                userDAO.addNewUser(userDict: userDict)
            }
            else{
                //Email already taken
            }
        }
        
    }
       

}
