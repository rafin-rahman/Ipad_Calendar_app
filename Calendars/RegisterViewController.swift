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
        
        if isValidEmailAddress(emailAddressString: email!){
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
        
        
        
    }
    
     func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    

}
