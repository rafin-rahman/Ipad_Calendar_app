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
    @IBOutlet weak var emailFieldView: UIView!
    @IBOutlet weak var passwordOneField: UITextField!
    @IBOutlet weak var passwordFieldView: UIView!
    @IBOutlet weak var passwordTwoField: UITextField!
    @IBOutlet weak var passwordTwoFieldView: UIView!
    
    
    @IBOutlet weak var emailWarningLabel: UILabel!
    @IBOutlet weak var passwordOneWarningLabel: UILabel!
    @IBOutlet weak var passwordTwoWarningLabel: UILabel!
    
    @IBOutlet weak var createAccountLabel: UILabel!
    
    @IBOutlet weak var textOne: UILabel!
    @IBOutlet weak var textTwo: UILabel!
    @IBOutlet weak var textThree: UILabel!
    @IBOutlet weak var textFour: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailWarningLabel.isHidden = true
        passwordOneWarningLabel.isHidden = true
        passwordTwoWarningLabel.isHidden = true
        
        textOne.adjustsFontSizeToFitWidth = true
        textTwo.adjustsFontSizeToFitWidth = true
        textThree.adjustsFontSizeToFitWidth = true
        textFour.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func registerButtonClick(_ sender: UIButton) {
        TextfieldAnimation.convertToNormal(view: emailFieldView)
        TextfieldAnimation.convertToNormal(view: passwordFieldView)
        TextfieldAnimation.convertToNormal(view: passwordTwoFieldView)
        
        emailWarningLabel.isHidden = true
        passwordOneWarningLabel.isHidden = true
        passwordTwoWarningLabel.isHidden = true
                
        let email = emailField.text
        // text validation
        if email == "" {
            emailWarningLabel.text = "Email cannot be empty"
            emailWarningLabel.isHidden = false
            TextfieldAnimation.errorAnimation(view: emailFieldView)
            return
        }
        
        if email?.isValidEmail ?? false == false{
            emailWarningLabel.text = "Not a valid Email Address"
            emailWarningLabel.isHidden = false
            TextfieldAnimation.errorAnimation(view: emailFieldView)
            return
        }

        let password = passwordOneField.text
        if password == ""{
            passwordOneWarningLabel.text = "Password cannot be empty"
            passwordOneWarningLabel.isHidden = false
            TextfieldAnimation.errorAnimation(view: passwordFieldView)
            return
        }
        
        let confirmPassword = passwordTwoField.text
        if confirmPassword == ""{
            passwordTwoWarningLabel.text = "Password cannot be empty"
            passwordTwoWarningLabel.isHidden = false
            TextfieldAnimation.errorAnimation(view: passwordTwoFieldView)
            return
        }
        
        if password != confirmPassword{
            passwordTwoWarningLabel.text = "Password do not match with each other"
            passwordTwoWarningLabel.isHidden = false
            TextfieldAnimation.errorAnimation(view: passwordFieldView)
            TextfieldAnimation.errorAnimation(view: passwordTwoFieldView)
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
 
