
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
        let profileReference = dbConnection.collection("User").document(UserSession.userDetails.id).collection("Profile")
        
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
        let profileReference = dbConnection.collection("User").document(UserSession.userDetails.id).collection("Profile")
        let newProfile = profileReference.document()
        newProfile.setData(profileDic);
    }
    
    func editProfile(profile:Profile){
        let profileReference = dbConnection.collection("User").document(UserSession.userDetails.id).collection("Profile").document(profile.id)
        profileReference.updateData([
            "Name" : profile.profileName,
            "Color" : profile.profileColor
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        
    }
    
    func deleteProfile(profileId:String){
        let profileReference = dbConnection.collection("User").document(UserSession.userDetails.id).collection("Profile")
        
        profileReference.document(profileId).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
