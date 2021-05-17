//
//  Matching.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/29.
//

import SwiftUI

// MARK: - result

// for set
struct SetMatching: Codable {
    var regTime: String
    var request: Request
    var reqUserData: RequestUserData
    var undUserData: UndertakeUserData
    var messages: [Message] = []
    var endTime: String = ""
    var status: MatchingStatus
}

// for get (ddlistener)
struct Matching: Codable, Identifiable, Equatable {
    static func == (lhs: Matching, rhs: Matching) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String // mid
    var regTime: String
    var request: Request
    var reqUserData: RequestUserData
    var undUserData: UndertakeUserData
    var messages: [Message]
    var endTime: String
    var status: MatchingStatus
    
    var itemsApxAmount: Int {
        var amount = 0
        for item in request.cart {
            amount += item.value + Int(item.quantity!)!
        }
        return amount
    }
    
    // 商品合計金額に対する仲介手数料(確定)
    var exaFee: Int {
        Int(floor(Double(undUserData.sentRecipt.exactAmount) * 0.01 * 10))
    }
    
    var totalExaAmount: Int {
        // items total + 仲介手数料10% + 報酬
        undUserData.sentRecipt.exactAmount + exaFee + request.reward
    }
    
    var paidToUndExaAmount: Int {
        // items total + 仲介手数料10% + 報酬
        undUserData.sentRecipt.exactAmount + request.reward
    }
    
}

struct MatchingStatus: Codable {
    var compReq: Bool = false
    var compUnd: Bool = false
    var cancelReq: Bool = false
    var cancelUnd: Bool = false
}

// MARK: - Subordinate

struct TimeAndBool: Codable {
    var time: String = ""
    var done: Bool = false
}

struct SentRecipt: Codable {
    var time: String = ""
    var done: Bool = false
    var exactAmount: Int = 0
}

struct Evaluate: Codable {
    var time: String = ""
    var done: Bool = false
    var value: Int = 0
    var comment: String = ""
}

struct RequestUserData: Codable {
    var uid: String
    var confirmedItemsAndFee: TimeAndBool = TimeAndBool()
    var transferedMoney: TimeAndBool = TimeAndBool()
    var evaluatePartner: Evaluate = Evaluate()
}

struct UndertakeUserData: Codable {
    var uid: String
    var suid: String
    var fmcToken: String
    var arrivedShop: TimeAndBool = TimeAndBool()
    var bought: TimeAndBool = TimeAndBool()
    var sentRecipt: SentRecipt = SentRecipt()
    var deliveried: TimeAndBool = TimeAndBool()
    var evaluatePartner: Evaluate = Evaluate()
}

struct Message: Codable, Hashable {
    var time: String
    var message: String
    var uid: String
    var readReq: Bool
    var readUnd: Bool
    
    var dictionary: [String: Any] {
        [
            "uid": uid,
            "time": time,
            "message": message,
            "readReq": readReq,
            "readUnd": readUnd
        ]
    }
}

