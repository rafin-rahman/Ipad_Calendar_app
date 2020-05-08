//
//  AddEditViewController.swift
//  Calendars
//
//  Created by Rafin Rahman on 20/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddEditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
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
    
    @IBOutlet weak var taskNameText: UITextField!
    @IBOutlet weak var taskReminderPicker: UIDatePicker!
    @IBOutlet weak var taskProfilePicker: UIPickerView!
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var taskTimePicker: UIDatePicker!
    @IBOutlet weak var taskPrioritySegment: UISegmentedControl!
    
    
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
    var eventEdit = false
    var taskEdit = false
    
    var profileNames: [String] = []
    var profileColours: [String] = []
    var selectedProfile : String = ""
    var selectedColor : String = ""
    
    var updateEvent : Events!
    var updateTask : Task!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskNameText.delegate = self
        eventDatePicker.date = activeDate
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        self.backgroundView.addGestureRecognizer(tap)
        
        self.reminderTimePicker.isEnabled = false
        self.recurrentSegment.isEnabled = false
        
        self.eventEndTimePicker.date = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        self.taskReminderPicker.isEnabled = false
        
        if self.isTask {
            selectedTab(selectedView: taskView, selectedButton: taskButton)
            taskNameText.becomeFirstResponder()
        } else {
            selectedTab(selectedView: eventView, selectedButton: eventButton)
            eventNameText.becomeFirstResponder()
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
        let singleTapSelector = #selector(self.onSingleTap)
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: singleTapSelector)
        view.addGestureRecognizer(singleTap)
    }
    
    @objc func onSingleTap(){
        view.endEditing(true)
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
        
        taskTimePicker.date = String("9:00").toDate(dateFormat: "hh:mm")
        taskTimePicker.locale = Locale(identifier: "en_GB")
        eventStartTimePicker.locale = Locale(identifier: "en_GB")
        eventEndTimePicker.locale = Locale(identifier: "en_GB")
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
        self.profileNames.append("Default")
        self.profileColours.append("Grey")
        
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
                    let profileColour = profile["Color"]
                    
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
            newColor = HexToUIColor.hexStringToUIColor(hex: "#ecf0f1", alpha: 1)
        case 1:
            newColor = .yellow
        case 2:
            newColor = .red
        default:
            print("Something went wrong in priorityValueChanged")
        }
        sender.selectedSegmentTintColor = newColor
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
            return
        }
        
        let selectedDate = eventDatePicker.date.toString(dateFormat: "dd-MM-yy")!
        
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
        
        
        
        if eventEdit{
            updateEvent.eventName = eventName!
            updateEvent.location = eventLocationText.text!
            updateEvent.startDate = startDate!
            updateEvent.endDate = endDate!
            updateEvent.allDay = allDayStatus
            updateEvent.reminder = reminderDate
            updateEvent.priority = priority!
            updateEvent.profile =  selectedProfile
            updateEvent.profileColour = selectedColor
            EventDAO().editEvent(updatedEvent: updateEvent)
            eventEdit = false
        }
        else{
            let eventDict: [String: Any] = [
                "Name" : eventName!,
                "Location" : eventLocationText.text!,
                "StartTime" : startDate!,
                "EndTime" : endDate!,
                "All-Day": allDayStatus,
                "ReminderTime" : reminderDate,
                "Priority" : priority!,
                "Profile" : selectedProfile,
                "ProfileColour" : selectedColor,
                "DeleteStatus" : false,
                "DeleteTime" : Date()
            ]
            EventDAO().addNewEvent(eventDict: eventDict)
        }
        onDismiss!()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func taskSaveButtonClick(_ sender: UIButton) {
        TextfieldAnimation.convertToNormal(textField: taskNameText)
        let taskName = taskNameText.text
        // text validation
        if taskName == "" {
            TextfieldAnimation.errorAnimation(textField: taskNameText)
            return
        }
        
        let selectedDate = taskDatePicker.date.toString(dateFormat: "dd-MM-yy")!
        let taskTime = taskTimePicker.date.toString(dateFormat: "HH:mm")!
        let startDate = (selectedDate + " " + taskTime).toDate(dateFormat: "dd-MM-yy HH:mm")
        
        let reminderTime = startDate!.timeIntervalSince1970 - taskReminderPicker.countDownDuration
        
        let reminderDate = Date(timeIntervalSince1970: reminderTime)
        
        
        let priority = taskPrioritySegment.titleForSegment(at: taskPrioritySegment.selectedSegmentIndex)
        
        if taskEdit{
            updateTask.taskName = taskName!
            updateTask.taskDateAndTime = startDate!
            updateTask.reminder = reminderDate
            updateTask.priority = priority!
            updateTask.profile =  selectedProfile
            updateTask.profileColour = selectedColor
            TaskDAO().editTask(updatedTask: updateTask)
            taskEdit = false
        }
        else{
            let taskDict: [String: Any] = [
                "Name" : taskName!,
                "DateAndTime" : startDate!,
                "ReminderTime" : reminderDate,
                "Priority" : priority!,
                "Profile" : selectedProfile,
                "ProfileColour" : selectedColor,
                "CompletedStatus": false,
                "DeleteStatus" : false,
                "DeleteTime" : Date()
            ]
            TaskDAO().addNewTask(taskDic: taskDict)
        }
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
    
    func eventEditDetails(event : Events) {
        eventEdit = true
        
        updateEvent = event
        
        eventNameText.text = event.eventName
        eventLocationText.text = event.location
        
        eventDatePicker.date = event.startDate
        eventStartTimePicker.date = event.startDate
        eventEndTimePicker.date = event.endDate
        
        allDaySwitch.isOn = event.allDay
        
        switch event.priority {
        case "Low":
            prioritySegment.selectedSegmentIndex = 0
        case "Medium":
            prioritySegment.selectedSegmentIndex = 1
            prioritySegment.selectedSegmentTintColor = .yellow
        case "High":
            prioritySegment.selectedSegmentIndex = 2
            prioritySegment.selectedSegmentTintColor = .red
        default:
            print("Something went wrong in priorityValueChanged")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
            let index = self.profileNames.firstIndex(of: event.profile)!
            self.eventProfilePicker.selectRow(index, inComponent: 0, animated: false)
            
            self.selectedProfile = event.profile
            self.selectedColor = event.profileColour
            
        }
        
        reminderTimePicker.isEnabled = true
        enableButton(enabledButton: reminderButton)
        reminderTimePicker.date.timeIntervalSince(event.reminder)
        taskButton.isHidden = true
        selectedTab(selectedView: eventView, selectedButton: eventButton)
    }
    
    func taskEditDetails(task : Task) {
        
        taskEdit = true
        
        updateTask = task
        
        taskNameText.text = task.taskName
        taskDatePicker.date = task.taskDateAndTime
        taskTimePicker.date = task.taskDateAndTime
        
        enableButton(enabledButton: taskReminderButton)
        taskReminderPicker.isEnabled = true
        taskReminderPicker.date.timeIntervalSince(task.reminder)
        
        switch task.priority {
        case "Low":
            taskPrioritySegment.selectedSegmentIndex = 0
        case "Medium":
            taskPrioritySegment.selectedSegmentIndex = 1
            taskPrioritySegment.selectedSegmentTintColor = .yellow
        case "High":
            taskPrioritySegment.selectedSegmentIndex = 2
            taskPrioritySegment.selectedSegmentTintColor = .red
        default:
            print("Something went wrong in priorityValueChanged")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
            let index = self.profileNames.firstIndex(of: task.profile)!
            self.taskProfilePicker.selectRow(index, inComponent: 0, animated: false)
            
            self.selectedProfile = task.profile
            self.selectedColor = task.profileColour
            
        }
        eventButton.isHidden = true
        selectedTab(selectedView: taskView, selectedButton: taskButton)
    }
    
    func selectedTab(selectedView: UIView, selectedButton:UIButton)
    {
        self.taskView.isHidden = true
        self.eventView.isHidden = true
        self.taskButton.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "8BB5FF", alpha: 1)
        self.eventButton.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "8BB5FF", alpha: 1)
        
        selectedView.isHidden = false
        selectedButton.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "273C75", alpha: 1)
    }
    
    func enableButton(enabledButton:UIButton){
        enabledButton.backgroundColor = UIColor(red: 0.62, green: 0.74, blue: 1.00, alpha: 1.00)
        enabledButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func disabledButon(disabledButton:UIButton){
        disabledButton.backgroundColor = UIColor(red: 0.53, green: 0.55, blue: 0.63, alpha: 1.00)
        disabledButton.setTitleColor(UIColor(red: 0.71, green: 0.73, blue: 0.79, alpha: 1.00), for: .normal)
    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        let text = textField.text!
        
        checkDate(text: text)
        checkTime(text: text)
        
        return true
    }
    
    func checkDate(text:String){
        if text.lowercased().range(of:"today") != nil{
            taskDatePicker.setDate(Calendar.current.date(byAdding: .day, value: 0, to: Date())!, animated: true)
        }
        
        if text.lowercased().range(of:"tomorrow") != nil{
            taskDatePicker.setDate(Calendar.current.date(byAdding: .day, value: 1, to: Date())!, animated: true)
        }
        
        if text.lowercased().range(of:"monday") != nil {
            taskDatePicker.setDate(Date().nextWeekDay(.monday), animated: true)
            
        }
        
        if text.lowercased().range(of:"tuesday") != nil {
            taskDatePicker.setDate(Date().nextWeekDay(.tuesday), animated: true)
            
        }
        
        if text.lowercased().range(of:"wednesday") != nil {
            taskDatePicker.setDate(Date().nextWeekDay(.wednesday), animated: true)
            
        }
        
        if text.lowercased().range(of:"thursday") != nil {
            taskDatePicker.setDate(Date().nextWeekDay(.thursday), animated: true)
            
        }
        
        if text.lowercased().range(of:"friday") != nil {
            taskDatePicker.setDate(Date().nextWeekDay(.friday), animated: true)
            
        }
        
        if text.lowercased().range(of:"saturday") != nil {
            taskDatePicker.setDate(Date().nextWeekDay(.saturday), animated: true)
            
        }
        
        if text.lowercased().range(of:"sunday") != nil {
            taskDatePicker.setDate(Date().nextWeekDay(.sunday), animated: true)
            
        }
        
        if text.lowercased().range(of:"january") != nil ||  text.lowercased().range(of:" jan") != nil {
            taskDatePicker.setDate(Date().nextMonth(.january), animated: true)
            
        }
        if text.lowercased().range(of:"february") != nil ||  text.lowercased().range(of:" feb") != nil {
            taskDatePicker.setDate(Date().nextMonth(.february), animated: true)
            
        }
        if text.lowercased().range(of:"march") != nil ||  text.lowercased().range(of:" mar") != nil {
            taskDatePicker.setDate(Date().nextMonth(.march), animated: true)
            
        }
        if text.lowercased().range(of:"april") != nil ||  text.lowercased().range(of:" apr") != nil {
            taskDatePicker.setDate(Date().nextMonth(.april), animated: true)
            
        }
        if text.lowercased().range(of:"may") != nil {
            taskDatePicker.setDate(Date().nextMonth(.may), animated: true)
            
        }
        if text.lowercased().range(of:"june") != nil ||  text.lowercased().range(of:" jun") != nil{
            taskDatePicker.setDate(Date().nextMonth(.june), animated: true)
            
        }
        if text.lowercased().range(of:"july") != nil ||  text.lowercased().range(of:" jul") != nil{
            taskDatePicker.setDate(Date().nextMonth(.july), animated: true)
            
        }
        if text.lowercased().range(of:"august") != nil ||  text.lowercased().range(of:" aug") != nil{
            taskDatePicker.setDate(Date().nextMonth(.august), animated: true)
            
        }
        if text.lowercased().range(of:"september") != nil ||  text.lowercased().range(of:" sep") != nil{
            taskDatePicker.setDate(Date().nextMonth(.september), animated: true)
            
        }
        if text.lowercased().range(of:"october") != nil ||  text.lowercased().range(of:" oct") != nil{
            taskDatePicker.setDate(Date().nextMonth(.october), animated: true)
            
        }
        if text.lowercased().range(of:"november") != nil ||  text.lowercased().range(of:" nov") != nil{
            taskDatePicker.setDate(Date().nextMonth(.november), animated: true)
            
        }
        
        if text.lowercased().range(of:"december") != nil ||  text.lowercased().range(of:" dec") != nil{
            taskDatePicker.setDate(Date().nextMonth(.december), animated: true)
        }
        
        if text.lowercased().range(of:"next month") != nil{
            taskDatePicker.setDate(Calendar.current.date(byAdding: .month, value: 1, to: taskDatePicker.date)!, animated: true)
        }
        
        if text.lowercased().range(of:"next year") != nil{
            taskDatePicker.setDate(Calendar.current.date(byAdding: .year, value: 1, to: taskDatePicker.date)!, animated: true)
        }
    }
    
    func checkTime(text:String){
        
        var hoursTiming:String!
        var minutesTiming:String!
        
        if text.lowercased().range(of:"an hour") != nil{
            taskTimePicker.setDate(Calendar.current.date(byAdding: .hour, value: 1, to: taskDatePicker.date)!, animated: true)
        }
        
        if text.lowercased().range(of:"half an hour") != nil{
            taskTimePicker.setDate(Calendar.current.date(byAdding: .minute, value: 30, to: taskDatePicker.date)!, animated: true)
        }
        
        if text.contains(":") && text.count > 4{
            let range: Range<String.Index> = text.range(of: ":")!
            
            let hours = text.index(before: range.upperBound)
            
            let wholeStringBefore = text.prefix(upTo: hours)
            var wholeStringAfter = text.suffix(from: hours)
            
            if wholeStringBefore.count > 1 {
                hoursTiming = wholeStringBefore.substring(from:wholeStringBefore.index(wholeStringBefore.endIndex, offsetBy: -2))
                hoursTiming = hoursTiming.replacingOccurrences(of: " ", with: "")
                
                if(hoursTiming.count == 1){
                    hoursTiming = "0" + hoursTiming
                }
                
                let hoursInt = Int(hoursTiming) ?? 00
                if hoursInt > 23 {
                    hoursTiming = "Wrong Time"
                }
            }
            
            if wholeStringAfter.count > 2{
                wholeStringAfter.remove(at: wholeStringAfter.startIndex)
                minutesTiming = String(wholeStringAfter.prefix(2))
                let minutesInt = Int(minutesTiming) ?? 00
                if minutesInt > 59 {
                    minutesTiming = "Wrong Time"
                }
            }
            
            if (hoursTiming != nil) && (minutesTiming != nil) && hoursTiming.count == 2 && minutesTiming.count == 2{
                if (minutesTiming != "Wrong Time") && (minutesTiming != "Wrong Time"){
                    
                    let date = String(hoursTiming+":"+minutesTiming).toDate(dateFormat: "HH:mm")
                    
                    let currentDate = Date().stripDate()
                    let selectedDate = date!.stripDate()
                                                            
                    if currentDate.timeIntervalSince(selectedDate) > 0{
                        taskDatePicker.setDate(Calendar.current.date(byAdding: .day, value: 1, to: Date())!, animated: true)
                    }
                    taskTimePicker.date = date!
                }
            }
        }
    }
}
 
