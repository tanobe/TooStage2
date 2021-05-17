//
//  SceneDelegate.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/01/20.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    // using this in the situation where user done the flow then want to return to root view
    func toContentView() {
        let contentView = ContentView()
        window?.rootViewController = UIHostingController(rootView: contentView)
    }
    
    // show View function
    func selectView<T: View>(_ view: T, _ scene: UIScene) {
        let view = view
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: view)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // Create the SwiftUI view that provides the window contents.
         selectView(ContentView().environment(\.locale, Locale(identifier: "ja_JP")), scene)

    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        
        // MARK: - delay view
        // The view to display to users who are redirected here
        
        // MARK: - Define each url
        enum UniversalLink: String {
            case stripe = "/stripe/"
            // other following ...
        }
        
        // MARK: - Get URL
        let url = userActivity.webpageURL
        let stringURL = url?.absoluteString ?? ""
        
        // loading time more than 3 sec

        // MARK: - Sort by url

        DispatchQueue.main.async {
            /* stripe */
            
            /*
             * YOU HAVE TO CHECK NOT ONLY "details_submitted" BUT ALSO "charges_enabled"
             */
            
            if let _ = stringURL.range(of: "\(UniversalLink.stripe)") {
                if let _ = stringURL.range(of: "/return.html") {
                    // you can get user's stripe account id
                    let extractAccountID = stringURL.components(separatedBy: "/return.html/")
                    let suid = extractAccountID[1]
                    
                    // create WebhookGet instance
                    let webhook = WebhookGetForStripe<Bool>(url: "\(backendURL)/stripeModule-retriveAccount", key: "details_submitted", body: "id=\(suid)")
                    
                    // check 'details_submitted' on /v1/account stripe API
                    let details_submitted: Bool = webhook.response!
                    UserData.shared.updateDocumentForPayAccount(
                        data: [
                            "onboardIs": true,
                            "suid": suid
                        ])
                    if let userActivity = scene.userActivity {
                        self.scene(scene, continue: userActivity)
                    }
                    
                    LoadingTrigger.shared.isOn = false
                    
                    // if details_submitted is false, tell the user that, it is ok but, you hove to finish onboarding later
                    if !details_submitted {
                        AlertTrigger.shared.onboardingNotFinished = true
                    }
                } else {
                    // redirect to refresh view
                    // You can transition back to the original view and anotation onboarding not be completed so
                    // redirect userActivity and show 'you have to try again'
                    LoadingTrigger.shared.isOn = false
                    if let userActivity = scene.userActivity {
                        self.scene(scene, continue: userActivity)
                    }
                    AlertTrigger.shared.failureOnbording = true
                }
            }

            /* other universal link directories follow ... */
        }
        
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}
