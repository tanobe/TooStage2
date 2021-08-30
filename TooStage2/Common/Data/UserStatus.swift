//
//  UserStatus.swift
//  TooStage2
//
// 
//

import SwiftUI
import FirebaseAuth
import FirebaseMessaging

class UserStatus: ObservableObject {
    // stock user status
    @Published var token: String? = nil
    // stock user id
    @Published var uid: String? = nil
    // stock user email address
    @Published var email: String? = nil
    // stock user notification token
    @Published var fmcToken: String? = nil
    // stock user stripe id
//    @Published var loggedIn = AuthViewModel()
    // create singleton object
    static let shared = UserStatus()
    
    func signOut() {
        token = nil
        uid = nil
        email = nil
        fmcToken = nil
    }
    
    func assignUidAndEmail() {
        uid = Auth.auth().currentUser?.uid
        email = Auth.auth().currentUser?.email
    }
    
    
    
    func assignTokenSigned() {
        token = "signed"
    }
    
    
    func assignTokenCompleted() {
        token = "completed"
        // auth done -> asigned token 'completed' -> set userData for shared and update fmcToken
        UserData.shared.getDocument(doc: uid!)
        
        Messaging.messaging().token { token, error in
          if let error = error {
            print("\nError fetching FCM registration token: \(error)\n")
          } else if let token = token {
            
            UserData.shared.updateDocument(data: ["fmcToken": token])
          }
        }
        
    }
    
    func assignTokenNil() {
        token = nil
    }
    
    func getCompleteDataFromFireStore() {
        
    }
    
    private init() {}
}
