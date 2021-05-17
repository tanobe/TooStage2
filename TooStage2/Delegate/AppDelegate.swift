//
//  AppDelegate.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/01/20.
//

import UIKit
import Firebase
import FirebaseMessaging
import Stripe
import UserNotificationsUI
import GoogleSignIn

// keys and url
let backendURL = "https://asia-northeast1-toostage2-27899.cloudfunctions.net"
let storageURL = "gs://toostage2-27899.appspot.com"
//let stripePublishableKey = "pk_live_51HhZfiFz5Pdlin5mpOh7H4hIk6AWe3Wi4jeTGLRmZdIeBnT8Rq5EFdTJC30A5slD2f5uPru0KS59T3V01ZPr4IVP00w3KGvxzu"
let stripePublishableKey = "pk_test_51HhZfiFz5Pdlin5m22cns8aag54NYb05ohOsmSBtpt5laRlrIcRKiixOugadB0CwA5yjzRFIXnEKW8Z0NCp8g6Cq00dFhC2f5V"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
    /** Configure firebaseApp */
        FirebaseApp.configure()
        
    /** Google SignIn Setting*/
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
    /** Stripe Setting*/
        // configure the SDK with my Stripe publishable key so that it can make requests to the Stripe API
        StripeAPI.defaultPublishableKey = stripePublishableKey
    
        
    /** FMC NOTIFICATION */
        // confirm user that can this app send you some notification
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        // get fmcToken and assing to UserStatus
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
          if let error = error {
            print("\nError fetching FCM registration token: \(error)\n")
          } else if let token = token {
            // userStatusに一時保管 assignTokenCompleted()を呼び出したときにfmcTokenをupdateする
            UserStatus.shared.fmcToken = token
            
            if UserData.shared.data != nil {
                UserData.shared.data?.fmcToken = token
            }
          }
        }
        // make topic for default
        Messaging.messaging().subscribe(toTopic: "request") { error in
          print("Subscribed to request topic")
        }
        Messaging.messaging().subscribe(toTopic: "announce") { error in
          print("Subscribed to announce topic")
        }
        
        
        return true
    }

    
    // MARK: URL Schemes
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }


    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        print("\n call app\n")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}


// NOTIFICATION
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    /** NOTIFICATION  */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
            // Print message ID.
            if let messageID = userInfo["gcm.message_id"] {
                print("Message ID: \(messageID)")
            }

            // Print full message.
            print(userInfo)
        }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print message ID.
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }

        print(userInfo)

        completionHandler([])
    }

    // background
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }

        print(userInfo)

        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("\nFirebase registration token: \(String(describing: fcmToken))\n")

        let dataDict:[String: String] = ["token": fcmToken ]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
