//
//  Payout.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/17.
//

import Foundation

struct Balance: Decodable {
    var available: Int
    var pending: Int
    var sum: Int {
        available + pending
    }
}

struct Result: Decodable {
    var result: String
}


class StripePayout: ObservableObject {
    
    static let shared = StripePayout()
    
    // MARK: - webhook
    @Published var balance = WebhookGet<Balance>()
    @Published var payout = WebhookPayoutResult()
    
    // 入金可能な残高
    var canPayoutAmount: Int {
        if (self.available - 300 < 0) {
            return 0
        }
        return self.available - 300
    }
    
    var sum: Int {
        return self.available + pending
    }
    
    var available: Int {
        guard let avalilable = balance.res?.available else {
            return 0
        }
        return avalilable
    }
    
    var pending: Int {
        guard let pending = balance.res?.pending else {
            return 0
        }
        return pending
    }
    
    init() {
        self.balance.get(url: "stripeModule-retriveBalance", body: ["suid": UserData.shared.data?.suid ?? ""])
    }
    
    func getBalanceAgain() {
        self.balance.get(url: "stripeModule-retriveBalance", body: ["suid": UserData.shared.data?.suid ?? ""])
    }
    
    // MARK: - amount data
    @Published var isOK: Bool? = nil
    @Published var errFee300: Bool = false
    @Published var inputAmount: String = "" {
        didSet {
            isValidAmount()
        }
    }
    
    
    
    func isValidAmount() {
        guard let amount = Int(self.inputAmount) else {
            self.isOK = false
            return
        }
        guard let available = self.balance.res?.available else {
            self.isOK = false
            return
        }
        
        if (0 > amount) || (amount > available) {
            self.isOK = false
            return
        }
        
        if (amount + 300 > available) {
            self.isOK = false
            self.errFee300 = true
            return
        }
        
        self.isOK = true
    }

}
