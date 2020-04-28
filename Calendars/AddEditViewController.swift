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
    
    var onDismiss : (() -> Void)?
    var activeDate: Date = Date()
    
    var isTask = false
    
    var profileNames: [String] = []
    var profileColours: [String] = []
    var selectedProfile : String = ""
    var selectedColor : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        eventDatePicker.date = activeDate
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        self.backgroundView.addGestureRecognizer(tap)
        
        self.reminderTimePicker.isEnabled = false
        self.recurrentSegment.isEnabled = false
        
        self.taskReminderPicker.isEnabled = false
        
        if self.isTask {
            selectedTab(selectedView: taskView, selectedButton: taskButton)
        } else {
            selectedTab(selectedView: eventView, selectedButton: eventButton)
        }
                
        formStyle()
        getProfileList()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
            self.eventProfilePicker.delegate = self
            self.eventProfilePicker.dataSource = self
            
            if(self.profileNames.count > 0)
            {
                self.selectedProfile = self.profileNames[0]
                self.selectedColor = self.profileColours[0]
            }
            
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
        
        
        ButtonDesign.roundedCorner(button: reminderButton)
        ButtonDesign.roundedCorner(button: recurringButton)
        ButtonDesign.roundedCorner(button: eventSaveButton)
        ButtonDesign.roundedCorner(button: eventCancelButton)
        
        ButtonDesign.roundedCorner(button: taskReminderButton)
        ButtonDesign.roundedCorner(button: taskSaveButton)
        ButtonDesign.roundedCorner(button: taskCancelButton)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return profileNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return profileNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedProfile = profileNames[row]
        selectedColor = profileColours[row]
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
                    let profileColour = profile["Colour"]
                    
                    self.profileNames.append(profileName as! String)
                    self.profileColours.append(profileColour as! String)
                }
            }
        }
        
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func allDaySwitchClick(_ sender: UISwitch) {
        self.eventStartTimePicker.isEnabled = !self.eventStartTimePicker.isEnabled
        self.eventEndTimePicker.isEnabled = !self.eventEndTimePicker.isEnabled
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
        selectedTab(selectedView: taskView, selectedButton: taskButton)
    }
    
    @IBAction func eventButtonClick(_ sender: UIButton) {
        selectedTab(selectedView: eventView, selectedButton: eventButton)
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        let selectedDate = dateFormatter.string(from: eventDatePicker.date)
        
        if(eventStartTimePicker.date > eventEndTimePicker.date)
        {
            //TO:DO A message to show start time should not be grater than end time
            return
        }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let startTime = timeFormatter.string(from: eventStartTimePicker.date)
        let endTime = timeFormatter.string(from: eventEndTimePicker.date)
        
        let startDate = (selectedDate + " " + startTime).toDate(dateFormat: "dd-MM-yy HH:mm")
        let endDate = (selectedDate+" "+endTime).toDate(dateFormat: "dd-MM-yy HH:mm")
        
        let reminderTime = startDate!.timeIntervalSince1970 - reminderTimePicker.countDownDuration
        let reminderDate = Date(timeIntervalSince1970: reminderTime)
        
        let priority = prioritySegment.titleForSegment(at: prioritySegment.selectedSegmentIndex)
        
        let allDayStatus = allDaySwitch.isOn
        
            
        let eventDict: [String: Any] = [
            "Name" : eventNameText.text!,
            "Location" : eventLocationText.text!,
            "StartTime" : startDate!,
            "EndTime" : endDate!,
            "All-Day": allDayStatus,
            "ReminderTime" : reminderDate,
            "Priority" : priority!,
            "Profile" : selectedProfile,
            "ProfileColour" : selectedColor
        ]
        
        EventDAO().addNewEvent(eventDict: eventDict)
        
        onDismiss!()
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func reminderButtonClick(_ sender: UIButton) {
        if(reminderTimePicker.isEnabled == false){
            reminderTimePicker.isEnabled = true
            enableButton(enabledButton: reminderButton)
            
        }
        else{
            self.reminderTimePicker.isEnabled = false
            disabledButon(disabledButton: reminderButton)
        }
        
    }
    
    @IBAction func recurringButtonClick(_ sender: UIButton) {
        if recurrentSegment.isEnabled == false{
            recurrentSegment.isEnabled = true
            enableButton(enabledButton: recurringButton)
        }
        else{
            recurrentSegment.isEnabled = false
            disabledButon(disabledButton: recurringButton)
        }
    }
    
    @IBAction func taskReminderButtonClick(_ sender: UIButton) {
        if(taskReminderPicker.isEnabled == false){
            taskReminderPicker.isEnabled = true
            enableButton(enabledButton: taskReminderButton)
            
        }
        else{
            self.taskReminderPicker.isEnabled = false
            disabledButon(disabledButton: taskReminderButton)
        }
    }
    
    func selectedTab(selectedView: UIView, selectedButton:UIButton)
    {
        self.taskView.isHidden = true
        self.eventView.isHidden = true
        self.taskButton.alpha = 0.8
        self.eventButton.alpha = 0.8
        
        selectedView.isHidden = false
        selectedButton.alpha = 1.0
    }
    
    func enableButton(enabledButton:UIButton){
        enabledButton.backgroundColor = UIColor(red: 0.62, green: 0.74, blue: 1.00, alpha: 1.00)
        enabledButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func disabledButon(disabledButton:UIButton){
        disabledButton.backgroundColor = UIColor(red: 0.53, green: 0.55, blue: 0.63, alpha: 1.00)
        disabledButton.setTitleColor(UIColor(red: 0.71, green: 0.73, blue: 0.79, alpha: 1.00), for: .normal)
    }
}
