//
//  FirebaseAuthAtHome.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/01/30.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn


// 最初のログイン
extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        ShopDetail.shared.dismissSheet()
        
        if let _ = error {
            print("auth false in sign")
            UserStatus.shared.assignTokenNil()
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(
            withIDToken: authentication.idToken,
            accessToken: authentication.accessToken)
        
        // MARK: - AuthManager でもこの処理をしている
        Auth.auth().signIn(with: credential) { (res, err) in
            if err != nil {
                UserStatus.shared.assignTokenNil()
            }
            UserStatus.shared.assignUidAndEmail()
            // Write "completed" in token
            // For this, current user pass the "signed" status
            // assign "signed" at FirestoreIsExist
            FirestoreIsExist(collection: "users", doc: UserStatus.shared.uid!).getIsDocument()
            // and then if there is the document of user, assign "completed" to status
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}

// 既にログインしている場合
class AuthManager: ObservableObject {
    
    private var handle: AuthStateDidChangeListenerHandle!
    
    init() {
        handle = Auth.auth().addStateDidChangeListener{ (auth, user) in
            if let _ = user {
                // MARK: - sign でもこの処理をしている
                // assign uid and email
                UserStatus.shared.assignUidAndEmail()
                // Write "completed" in token
                // For this, current user complete the sign in flow
                // assign "signed" at FirestoreIsExist
                FirestoreIsExist(collection: "users", doc: UserStatus.shared.uid!).getIsDocument()
                print("\n authUI 2 true\n")
                // MARK: - End
            } else {
                UserStatus.shared.assignTokenNil()
                print("\n authUI 2 false\n")
            }
        }
    }
    
    deinit {
        print("\nAuthManager deinit\n")
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
}
