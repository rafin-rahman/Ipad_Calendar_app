
import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class ProfileDAO{
    let dbConnection:Firestore
        
    init() {
        dbConnection = Firestore.firestore()
    }
}
