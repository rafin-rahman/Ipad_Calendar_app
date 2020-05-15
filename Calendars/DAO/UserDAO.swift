
import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class UserDAO{
    let dbConnection:Firestore
    var user : UserDetails!
            
    init() {
        dbConnection = Firestore.firestore()
    }
    
    func addNewUser(userDict:Dictionary<String, Any>){
        let userReference = dbConnection.collection("User")
        let newUser = userReference.document()
        newUser.setData(userDict);
    }
    
    func getAllUser(email:String){
        let userReference = dbConnection.collection("User").whereField("Email", isEqualTo: email)
        userReference.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } 
            else {
                for checkingUser in querySnapshot!.documents {
                    self.user.id = (checkingUser.documentID)
                    self.user.email = checkingUser["Email"] as! String
                    self.user.password = checkingUser["Password"] as! String
                }
            }
        }
    }
    
    func validateUser(email:String, password: String){
        let userReference = dbConnection.collection("User").whereField("Email", isEqualTo: email).whereField("Password", isEqualTo: password)
        userReference.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for checkingUser in querySnapshot!.documents {
                    let userDetails = UserDetails()
                    
                    userDetails.id = (checkingUser.documentID)
                    userDetails.email = checkingUser["Email"] as! String
                    userDetails.password = checkingUser["Password"] as! String
                    
                    self.user = userDetails
                }
            }
        }
    }
}
