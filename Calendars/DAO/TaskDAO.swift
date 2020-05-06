import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class TaskDAO{
    let dbConnection:Firestore
    
    var taskList : Array<Task> = Array()
    
    init() {
        dbConnection = Firestore.firestore()
    }
    
    func addNewTask(taskDic:Dictionary<String, Any>){
        let taskReference = dbConnection.collection("User").document("Subin").collection("Task")
        let newTask = taskReference.document()
        newTask.setData(taskDic);
    }
    
    func getAllTask(){
        let taskReference = dbConnection.collection("User").document("Subin").collection("Task").whereField("DeleteStatus", isEqualTo: false)
        taskReference.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for task in querySnapshot!.documents {
                    
                    let newTask = Task()
                    
                    newTask.id = (task.documentID)
                    newTask.taskName = task["Name"] as! String
                    newTask.priority = task["Priority"] as! String
                    newTask.profile = task["Profile"] as! String
                    newTask.profileColour = task["ProfileColour"] as! String
                    newTask.completedStatus = task["CompletedStatus"] as! Bool
                    if let convertedDate = task["DateAndTime"] as? Timestamp {
                        newTask.taskDateAndTime = convertedDate.dateValue()
                    }
                    
                    if let convertedDate = task["ReminderTime"] as? Timestamp{
                        newTask.reminder = convertedDate.dateValue()
                    }
                    self.taskList.append(newTask)
                }
            }
        }
    }
    
    func getAllTasksFromDays(startDate:Date, endDate:Date){
        let taskReference = dbConnection.collection("User").document("Subin").collection("Task")
        let taskStartingToday = taskReference.whereField("DateAndTime", isGreaterThanOrEqualTo: startDate).whereField("DateAndTime", isLessThan: endDate).whereField("DeleteStatus", isEqualTo: false)
        taskStartingToday.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for task in querySnapshot!.documents {
                    
                    let newTask = Task()
                    
                    newTask.id = (task.documentID)
                    newTask.taskName = task["Name"] as! String
                    newTask.priority = task["Priority"] as! String
                    newTask.profile = task["Profile"] as! String
                    newTask.profileColour = task["ProfileColour"] as! String
                    newTask.completedStatus = task["CompletedStatus"] as! Bool
                    if let convertedDate = task["DateAndTime"] as? Timestamp {
                        newTask.taskDateAndTime = convertedDate.dateValue()
                    }
                    
                    if let convertedDate = task["ReminderTime"] as? Timestamp{
                        newTask.reminder = convertedDate.dateValue()
                    }
                    self.taskList.append(newTask)
                }
            }
        }
    }
    
    func getAllTasksFromToday(){
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let start = calendar.date(from: components)!
        
        let taskReference = dbConnection.collection("User").document("Subin").collection("Task")
        print("Start Time",start)
        let taskStartingToday = taskReference.whereField("DateAndTime", isGreaterThanOrEqualTo: start).whereField("DeleteStatus", isEqualTo: false)
        taskStartingToday.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for task in querySnapshot!.documents {
                    
                    let newTask = Task()
                    
                    newTask.id = (task.documentID)
                    newTask.taskName = task["Name"] as! String
                    newTask.priority = task["Priority"] as! String
                    newTask.profile = task["Profile"] as! String
                    newTask.profileColour = task["ProfileColour"] as! String
                    newTask.completedStatus = task["CompletedStatus"] as! Bool
                    if let convertedDate = task["DateAndTime"] as? Timestamp {
                        newTask.taskDateAndTime = convertedDate.dateValue()
                    }
                    
                    if let convertedDate = task["ReminderTime"] as? Timestamp{
                        newTask.reminder = convertedDate.dateValue()
                    }
                    self.taskList.append(newTask)
                }
            }
        }
    }
    
    func getAllTasksFromProfile(profile:String){
        let taskReference = dbConnection.collection("User").document("Subin").collection("Task").whereField("Profile", isEqualTo: profile)
        taskReference.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for task in querySnapshot!.documents {
                    
                    let newTask = Task()
                    
                    newTask.id = (task.documentID)
                    newTask.taskName = task["Name"] as! String
                    newTask.priority = task["Priority"] as! String
                    newTask.profile = task["Profile"] as! String
                    newTask.profileColour = task["ProfileColour"] as! String
                    newTask.completedStatus = task["CompletedStatus"] as! Bool
                    if let convertedDate = task["DateAndTime"] as? Timestamp {
                        newTask.taskDateAndTime = convertedDate.dateValue()
                    }
                    
                    if let convertedDate = task["ReminderTime"] as? Timestamp{
                        newTask.reminder = convertedDate.dateValue()
                    }
                    self.taskList.append(newTask)
                }
            }
        }
    }
    
    func getAllTasks(completedStatus:Bool){
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let start = calendar.date(from: components)!
        
        let taskReference = dbConnection.collection("User").document("Subin").collection("Task")
        print("Start Time",start)
        let taskStartingToday = taskReference.whereField("DeleteStatus", isEqualTo: false).whereField("CompletedStatus", isEqualTo: completedStatus)
        taskStartingToday.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for task in querySnapshot!.documents {
                    
                    let newTask = Task()
                    
                    newTask.id = (task.documentID)
                    newTask.taskName = task["Name"] as! String
                    newTask.priority = task["Priority"] as! String
                    newTask.profile = task["Profile"] as! String
                    newTask.profileColour = task["ProfileColour"] as! String
                    newTask.completedStatus = task["CompletedStatus"] as! Bool
                    if let convertedDate = task["DateAndTime"] as? Timestamp {
                        newTask.taskDateAndTime = convertedDate.dateValue()
                    }
                    
                    if let convertedDate = task["ReminderTime"] as? Timestamp{
                        newTask.reminder = convertedDate.dateValue()
                    }
                    self.taskList.append(newTask)
                }
            }
        }
    }
    
    func editDeleteStatus(id:String, deleteStatus:Bool){
        let taskReference = dbConnection.collection("User").document("Subin").collection("Task").document(id)
        
        taskReference.updateData([
            "DeleteStatus": deleteStatus,
            "DeleteTime" : Date()
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func editTaskCompleted(taskId:String, completed:Bool){
        let taskRef = dbConnection.collection("User").document("Subin").collection("Task").document(taskId)
        taskRef.updateData([
            "CompletedStatus":completed
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func editTask(updatedTask:Task){
        let taskRef = dbConnection.collection("User").document("Subin").collection("Task").document(updatedTask.id)
        taskRef.updateData([
            "Name" : updatedTask.taskName,
            "DateAndTime" : updatedTask.taskDateAndTime,
            "ReminderTime" : updatedTask.reminder,
            "Priority" : updatedTask.priority,
            "Profile" : updatedTask.profile,
            "ProfileColour" : updatedTask.profileColour
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func deleteTask(taskId:String){
        let taskRef = dbConnection.collection("User").document("Subin").collection("Task")
        
        taskRef.document(taskId).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func getAllDeletedTask(){
        let taskRef = dbConnection.collection("User").document("Subin").collection("Task").order(by: "DeleteTime", descending: true)
        
        let deletedEvents = taskRef.whereField("DeleteStatus", isEqualTo: true)
        deletedEvents.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for task in querySnapshot!.documents {
                    
                    let newTask = Task()
                    
                    newTask.id = (task.documentID)
                    newTask.taskName = task["Name"] as! String
                    newTask.priority = task["Priority"] as! String
                    newTask.profile = task["Profile"] as! String
                    newTask.profileColour = task["ProfileColour"] as! String
                    newTask.completedStatus = task["CompletedStatus"] as! Bool
                    if let convertedDate = task["DateAndTime"] as? Timestamp {
                        newTask.taskDateAndTime = convertedDate.dateValue()
                    }
                    
                    if let convertedDate = task["ReminderTime"] as? Timestamp{
                        newTask.reminder = convertedDate.dateValue()
                    }
                    self.taskList.append(newTask)
                }
            }
        }
    }
}
