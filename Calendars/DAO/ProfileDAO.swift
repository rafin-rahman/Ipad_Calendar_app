
import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class ProfileDAO{
    let dbConnection:Firestore
    
    var profileList : Array<Profile> = Array()
        
    init() {
        dbConnection = Firestore.firestore()
    }
    
    func getProfileList(){
        let profileReference = dbConnection.collection("User").document("Subin").collection("Profile")
        
        profileReference.getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for profile in querySnapshot!.documents {
                    
                    let newProfile = Profile()
                    
                    newProfile.id = (profile.documentID)
                    newProfile.profileName = profile["Name"] as! String
                    newProfile.profileColor = profile["Color"] as! String
                        
                    self.profileList.append(newProfile)
                }
            }
        }
    }
    
    func addProfile(profileDic:Dictionary<String, Any>){
        let profileReference = dbConnection.collection("User").document("Subin").collection("Profile")
        let newProfile = profileReference.document()
        newProfile.setData(profileDic);
    }
}
