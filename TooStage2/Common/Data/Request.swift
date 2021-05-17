//
//  Request.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/11.
//

import SwiftUI

// MARK: - Request Data for Set to Firestore

struct SetRequest: Codable {
    let sid: String
    let shopName: String
    let regTime: String
    let uid: String
    let fmcToken: String
    let sex: String
    let cart: [Item]
    let deliveryAddress: String
    let deliveryMethod: String
    let reward: Int
    let memo: String
    var matched: Bool = false
    var validity: Bool = true
    var timeOut: Bool = false
}

// MARK: - Request Data for Get from Firestore
// it will be removed over time at firestore
class Request: Codable, Identifiable, Equatable, ObservableObject {
    
    static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.id == rhs.id && lhs.regTime == rhs.regTime
    }
    
    var id: String // uid + regtime
    let sid: String
    let shopName: String
    let regTime: String
    let uid: String
    let fmcToken: String
    let sex: String
    let cart: [Item]
    let deliveryMethod: String
    let deliveryAddress: String
    var reward: Int
    let memo: String
    var matched: Bool
    var validity: Bool
    var timeOut: Bool
    
    /** stop listening real time if the user transition home screen
     */
    @Published var stopListen: Bool = false
    
    enum CodingKeys: CodingKey {
        case id
        case sid
        case shopName
        case regTime
        case uid
        case fmcToken
        case sex
        case cart
        case deliveryMethod
        case deliveryAddress
        case reward
        case memo
        case matched
        case validity
        case timeOut
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.sid = try container.decode(String.self, forKey: .sid)
        self.shopName = try container.decode(String.self, forKey: .shopName)
        self.regTime = try container.decode(String.self, forKey: .regTime)
        self.uid = try container.decode(String.self, forKey: .uid)
        self.fmcToken = try container.decode(String.self, forKey: .fmcToken)
        self.sex = try container.decode(String.self, forKey: .sex)
        self.cart = try container.decode([Item].self, forKey: .cart)
        self.deliveryMethod = try container.decode(String.self, forKey: .deliveryMethod)
        self.deliveryAddress = try container.decode(String.self, forKey: .deliveryAddress)
        self.reward = try container.decode(Int.self, forKey: .reward)
        self.memo = try container.decode(String.self, forKey: .memo)
        self.matched = try container.decode(Bool.self, forKey: .matched)
        self.validity = try container.decode(Bool.self, forKey: .validity)
        self.timeOut = try container.decode(Bool.self, forKey: .timeOut)
        
        for item in cart {
            item.loadImage()
        }
    }
    
    // 商品合計数
    var itemsTotalCaunt: Int {
        var amount = 0
        for item in cart {
            amount += Int(item.quantity!)!
        }
        return amount
    }
    
    // 商品合計金額
    var itemsApxAmount: Int {
        var amount = 0
        for item in cart {
            amount += item.value * Int(item.quantity!)!
        }
        return amount
    }
    
    // 商品合計金額に対する仲介手数料(およそ)
    var apxFee: Int {
        Int(floor(Double(itemsApxAmount) * 0.01 * 10))
    }
    
    var totalApxAmount: Int {
        // item apx total + 仲介手数料10% + 報酬
        itemsApxAmount + apxFee + reward
    }

}
