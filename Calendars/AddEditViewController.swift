//
//  AddEditViewController.swift
//  Calendars
//
//  Created by Rafin Rahman on 20/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit
import Firebase

class AddEditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var taskView: UIView!
    
    
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var allDaySwitch: UISwitch!
    //Form Details
    @IBOutlet weak var eventNameText: UITextField!
    @IBOutlet weak var eventLocationText: UITextField!
    @IBOutlet weak var reminderTimePicker: UIDatePicker!
    @IBOutlet weak var recurrentSegment: UISegmentedControl!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    @IBOutlet weak var eventProfilePicker: UIPickerView!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var eventStartTimePicker: UIDatePicker!
    @IBOutlet weak var eventEndTimePicker: UIDatePicker!
    
    @IBOutlet weak var taskReminderPicker: UIDatePicker!
    @IBOutlet weak var taskProfilePicker: UIPickerView!
    
    // Event Buttons
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var recurringButton: UIButton!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var taskButton: UIButton!
    @IBOutlet weak var eventSaveButton: UIButton!
    @IBOutlet weak var eventCancelButton: UIButton!
    
    // Task Buttons
    @IBOutlet weak var taskSaveButton: UIButton!
    @IBOutlet weak var taskCancelButton: UIButton!
    @IBOutlet weak var taskReminderButton: UIButton!
    
    
    
    var isTask = false
    
    var pickerData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        self.backgroundView.addGestureRecognizer(tap)
        
        self.reminderTimePicker.isEnabled = false
        self.recurrentSegment.isEnabled = false

        self.taskReminderPicker.isEnabled = false
        
        if self.isTask {
            self.taskView.isHidden = false
            self.eventView.isHidden = true
            self.taskButton.alpha = 1
            self.eventButton.alpha = 0.8
        } else {
            self.taskView.isHidden = true
            self.eventView.isHidden = false
            self.taskButton.alpha = 0.8
            self.eventButton.alpha = 1
        }

        formStyle()
        getProfileList()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
            self.eventProfilePicker.delegate = self
            self.eventProfilePicker.dataSource = self
            
            self.taskProfilePicker.delegate = self
            self.taskProfilePicker.dataSource = self
        }
    }
    
    func formStyle(){
        boxView.layer.cornerRadius = 10
        boxView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        boxView.layer.shadowOffset = CGSize(width: 3.0, height: 5.0)
        boxView.layer.shadowOpacity = 1
        boxView.layer.shadowRadius = 3
        
        allDaySwitch.onTintColor = .lightGray
        
        /*For off state*/
        allDaySwitch.tintColor = .darkGray
        allDaySwitch.layer.cornerRadius = allDaySwitch.frame.height / 2
        allDaySwitch.backgroundColor = .darkGray
        
        
        reminderButton.layer.cornerRadius = 7
        recurringButton.layer.cornerRadius = 7
        eventSaveButton.layer.cornerRadius = 7
        eventCancelButton.layer.cornerRadius = 7
        
        taskSaveButton.layer.cornerRadius = 7
        taskCancelButton.layer.cornerRadius = 7
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func getProfileList(){
        let dbConnection = Firestore.firestore()
        let profileReference = dbConnection.collection("User").document("Subin").collection("Profile")
        profileReference.getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for profile in querySnapshot!.documents {
                    let profileName = profile["Name"]
                    self.pickerData.append(profileName as! String)
                }
            }
        }
        
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func priorityValueChanged(_ sender: UISegmentedControl) {
        var newColor = UIColor.black
        switch sender.selectedSegmentIndex {
        case 0:
            newColor = .white
        case 1:
            newColor = .yellow
            
        case 2:
            newColor = .red
        default:
            print("Something went wrong in priorityValueChanged")
        }
        prioritySegment.selectedSegmentTintColor = newColor
        
    }
    
    @IBAction func taskButtonClick(_ sender: UIButton) {
        eventView.isHidden = true
        taskView.isHidden = false
        taskButton.alpha = 1
        eventButton.alpha = 0.8
        
    }
    @IBAction func eventButtonClick(_ sender: UIButton) {
        taskView.isHidden = true
        eventView.isHidden = false
        taskButton.alpha = 0.8
        eventButton.alpha = 1
    }
    @IBAction func eventCancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func eventSaveClick(_ sender: UIButton) {
        
        TextfieldAnimation.convertToNormal(textField: eventNameText)
        let eventName = eventNameText.text
        // text validation
        if eventName == "" {
            TextfieldAnimation.errorAnimation(textField: eventNameText)
        }
        //        let dbConnection = Firestore.firestore()
        //        let eventReference = dbConnection.collection("User").document("Subin").collection("Event")
        //
        //        let newEvent = eventReference.document()
        //        newEvent.setData([
        //            "Name" : eventNameText.text,
        //            "Location" : eventLocationText.text
        //        ])
    }
    @IBAction func reminderButtonClick(_ sender: UIButton) {
        if(reminderTimePicker.isEnabled == false){
            reminderTimePicker.isEnabled = true
            reminderButton.backgroundColor = UIColor(red: 0.62, green: 0.74, blue: 1.00, alpha: 1.00)
            reminderButton.setTitleColor(UIColor.white, for: .normal)
            
        }
        else{
            self.reminderTimePicker.isEnabled = false
            reminderButton.backgroundColor = UIColor(red: 0.53, green: 0.55, blue: 0.63, alpha: 1.00)
            reminderButton.setTitleColor(UIColor(red: 0.71, green: 0.73, blue: 0.79, alpha: 1.00), for: .normal)
        }
        
    }
    
    @IBAction func recurringButtonClick(_ sender: UIButton) {
        if recurrentSegment.isEnabled == false{
            recurrentSegment.isEnabled = true
            recurringButton.backgroundColor = UIColor(red: 0.62, green: 0.74, blue: 1.00, alpha: 1.00)
            recurringButton.setTitleColor(UIColor.white, for: .normal)
        }
        else{
            recurrentSegment.isEnabled = false
            recurringButton.backgroundColor = UIColor(red: 0.53, green: 0.55, blue: 0.63, alpha: 1.00)
            recurringButton.setTitleColor(UIColor(red: 0.71, green: 0.73, blue: 0.79, alpha: 1.00), for: .normal)
        }
    }
    
    @IBAction func taskReminderButtonClick(_ sender: UIButton) {
        if(taskReminderPicker.isEnabled == false){
            taskReminderPicker.isEnabled = true
            taskReminderButton.backgroundColor = UIColor(red: 0.62, green: 0.74, blue: 1.00, alpha: 1.00)
            taskReminderButton.setTitleColor(UIColor.white, for: .normal)
            
        }
            
        else{
            self.taskReminderPicker.isEnabled = false
            taskReminderButton.backgroundColor = UIColor(red: 0.53, green: 0.55, blue: 0.63, alpha: 1.00)
            taskReminderButton.setTitleColor(UIColor(red: 0.71, green: 0.73, blue: 0.79, alpha: 1.00), for: .normal)
        }
    }
    
    
    
    
    
}
