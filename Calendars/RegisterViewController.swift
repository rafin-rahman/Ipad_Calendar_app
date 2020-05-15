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
    
    
    @IBOutlet weak var emailWarningLabel: UILabel!
    @IBOutlet weak var passwordOneWarningLabel: UILabel!
    @IBOutlet weak var passwordTwoWarningLabel: UILabel!
    
    @IBOutlet weak var createAccountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailWarningLabel.isHidden = true
        passwordOneWarningLabel.isHidden = true
        passwordTwoWarningLabel.isHidden = true
    }
    
    @IBAction func registerButtonClick(_ sender: UIButton) {
        TextfieldAnimation.convertToNormal(textField: emailField)
        TextfieldAnimation.convertToNormal(textField: passwordOneField)
        TextfieldAnimation.convertToNormal(textField: passwordTwoField)
        
        emailWarningLabel.isHidden = true
        passwordOneWarningLabel.isHidden = true
        passwordTwoWarningLabel.isHidden = true
                
        let email = emailField.text
        // text validation
        if email == "" {
            emailWarningLabel.text = "Email cannot be empty"
            emailWarningLabel.isHidden = false
            TextfieldAnimation.errorAnimation(textField: emailField)
            return
        }
        
        if email?.isValidEmail ?? false == false{
            emailWarningLabel.text = "Not a valid Email Address"
            emailWarningLabel.isHidden = false
            TextfieldAnimation.errorAnimation(textField: emailField)
            return
        }

        let password = passwordOneField.text
        if password == ""{
            passwordOneWarningLabel.text = "Password cannot be empty"
            passwordOneWarningLabel.isHidden = false
            TextfieldAnimation.errorAnimation(textField: passwordOneField)
            return
        }
        
        let confirmPassword = passwordTwoField.text
        if confirmPassword == ""{
            passwordTwoWarningLabel.text = "Password cannot be empty"
            passwordTwoWarningLabel.isHidden = false
            TextfieldAnimation.errorAnimation(textField: passwordTwoField)
            return
        }
        
        if password != confirmPassword{
            passwordTwoWarningLabel.text = "Password do not match with each other"
            passwordTwoWarningLabel.isHidden = false
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
                self.emailField.text = ""
                self.passwordOneField.text = ""
                self.passwordTwoField.text = ""
                self.createAccountLabel.text = "Registered Successfully"
                self.createAccountLabel.textColor = .green
            }
            else{
                self.emailWarningLabel.text = "Email has already been registered"
                self.emailWarningLabel.isHidden = false
                return
            }
        }
        
    }
       

}
 
