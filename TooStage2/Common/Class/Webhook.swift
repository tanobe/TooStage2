//
//  Webhook.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/26.
//

import SwiftUI

class WebhookGetForStripe<T> {
    
    let url: URL
    let key: String
    let body: String
    var response: T?
    
    init(url: String, key: String, body: String) {
        self.url = URL(string: url)!
        self.key = key
        self.body = body
        
        get()
    }
    
    // with: self.url -> with: request ??
    func get() {
        var request = URLRequest(url: self.url)
        // default method is "POST"
        request.httpBody = self.body.data(using: .utf8)
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: self.url) { (data, response, error) in
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            self.response = json?["\(self.key)"] as? T
            semaphore.signal()
        }.resume()
        _ = semaphore.wait(timeout: .distantFuture)
    }
}

class Webhook {
    
    static let shared = Webhook()
    
    func post(url: String, body: [String: Any]) {
        let url = URL(string: "\(backendURL)/" + url )!
        var request = URLRequest(url: url)
        let data = try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request)
        task.resume()
    }
}

class WebhookGet<T: Decodable>: ObservableObject {
    
    @Published var res: T?
    
    func get(url: String, body: [String: Any]) {
        let url = URL(string: "\(backendURL)/" + url )!
        var request = URLRequest(url: url)
        let data = try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            do {
                try DispatchQueue.main.sync {
                    self.res = try decoder.decode(T.self, from: data)
                }
            } catch {
                print("error")
            }
        }
        task.resume()
    }
}

class WebhookPayoutResult: ObservableObject {
    
    @Published var success = false
    @Published var failure = false
    @Published var loading = false
    
    var amount: Int?
    
    @Published var res: Result? {
        didSet {
            if self.res?.result == "success" {
                self.loading = false
                self.success = true
                
                // payout success and set history data to firestore
                let payoutHisData = SetPayoutHistory(time: Date().dateToString(), description: "入金処理", amount: self.amount!)
                let suid = UserData.shared.data?.suid ?? ""
                let doc = suid + " " + Date().dateToSimpleStringFormat()
                FirestoreSet(collection: "users/\(UserStatus.shared.uid!)/payoutHistories").set(data: payoutHisData, document: doc)

                
            } else if self.res?.result == "failure" {
                self.loading = false
                self.failure = true
            }
        }
    }

    func get(url: String, amount: Int, suid: String) {
        
        let body: [String: Any] = [
            "amount": amount,
            "suid": suid
        ]
        self.amount = amount
        
        let url = URL(string: "\(backendURL)/" + url )!
        var request = URLRequest(url: url)
        let data = try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            do {
                try DispatchQueue.main.sync {
                    self.res = try decoder.decode(Result.self, from: data)
                }
            } catch {
                print("error: \(error)")
            }
        }
        task.resume()
    }
}


class WebhookGetResult: ObservableObject {
    
    @Published var success = false
    @Published var failure = false
    @Published var loading = false
    @Published var res: Result? {
        didSet {
            if self.res?.result == "success" {
                self.loading = false
                self.success = true
            } else if self.res?.result == "failure" {
                self.loading = false
                self.failure = true
            }
        }
    }

    func get(url: String, body: [String: Any]) {
        let url = URL(string: "\(backendURL)/" + url )!
        var request = URLRequest(url: url)
        let data = try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            do {
                try DispatchQueue.main.sync {
                    self.res = try decoder.decode(Result.self, from: data)
                }
            } catch {
                print("error: \(error)")
            }
        }
        task.resume()
    }
}

class WebhookSendMail: ObservableObject {
    
    @Published var success = false
    @Published var failure = false
    @Published var loading = false
    @Published var res: Result? {
        didSet {
            if self.res?.result == "success" {
                self.loading = false
                self.success = true
            } else if self.res?.result == "failure" {
                self.loading = false
                self.failure = true
            }
        }
    }
    
    func sendMessage(text: String, subject: String) {
        self.loading = true
        let resText = text + " " +
            "Email: \(UserStatus.shared.email!) " +
            "uid: \(UserStatus.shared.uid!) "
        let body: [String: Any] = [
            "from": UserStatus.shared.email!,
            "to": "too.for.us@gmail.com",
            "subject": subject,
            "msg": resText
        ]
        self.get(url: "sendMail", body: body)
    }


    func get(url: String, body: [String: Any]) {
        let url = URL(string: "\(backendURL)/" + url )!
        var request = URLRequest(url: url)
        let data = try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            do {
                try DispatchQueue.main.sync {
                    self.res = try decoder.decode(Result.self, from: data)
                }
            } catch {
                print("error: \(error)")
            }
        }
        task.resume()
    }
}
