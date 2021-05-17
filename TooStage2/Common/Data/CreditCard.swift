//
//  CreditCard.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/13.
//

import SwiftUI

struct CreditCard: Codable {
    var number: String
    var expMonth: Int
    var expYear: Int
    var cvc: String
    var last4: String
    
    var data: [String: Any] {
        [
            "number": number,
            "expMonth": expMonth,
            "expYear": expYear,
            "cvc": cvc,
            "last4": last4
        ]
    }
}

