//
//  UIPayViewController.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/02/04.
//

import UIKit
import SafariServices
import Stripe

class CloudFunctionsWithStripe {

    func createAccount() {
        // access createAccount
//        let userData: UserInfo =
        let url = URL(string: "\(backendURL)/stripeModule-createAccount")
        var request = URLRequest(url: url!)
        
        // server side get user document from firestore and set data to 'stripe.account.create'
        let body = "uid=\(UserStatus.shared.uid!)"
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error  in
            guard let data = data else {
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : String]
            let state = json?["state"]!
            
            switch state {
            case "success":
                let suid = json?["id"]
                print("createAccountLink")
                createAccountLink(suid: suid!)
            case "failure":
                // you can show actionSheet to user
                print("\n error: \(String(describing: json?["err"]!)) \n")
            default:
                return
            }
        }
        task.resume()
    }
    
    func createAccountLink(suid: String) {
        // get suid as argument
        let url = URL(string: "\(backendURL)/stripeModule-createAccountLink")
        var request = URLRequest(url: url!)
        request.httpBody = "id=\(suid)".data(using: .utf8)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("un....")
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : String]
            let state = json?["state"]!
            switch state! {
            case "success":
                let url = json?["url"] ?? nil
                let onboardingURL = URL(string: url!)
                DispatchQueue.main.async {
                    if UIApplication.shared.canOpenURL(onboardingURL!) {
                        UIApplication.shared.open(onboardingURL!)
                    } else {
                        print("\n could't open the onboarding url... \n")
                    }
                }
                
            case "failure":
                // you can show actionSheet to user
                print("\n error: \(json!["err"]!) \n")
            default:
                print("default")
                return
            }
        }
        task.resume()
        
    }

    
}
