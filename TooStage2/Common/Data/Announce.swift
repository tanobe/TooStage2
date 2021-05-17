//
//  Announce.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/26.
//

import SwiftUI

// MARK: - Announce
// it will be removed over time at firestore
class Announce: Codable, Identifiable, Equatable, ObservableObject {
    static func == (lhs: Announce, rhs: Announce) -> Bool {
        return lhs.id == rhs.id && lhs.timeLimit == rhs.timeLimit
    }
    var id: String
    var uid: String
    var sex: String
    var timeLimit: String
    var validity: Bool
    
    enum CodingKeys: CodingKey {
        case id
        case uid
        case sex
        case timeLimit
        case validity
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.uid = try container.decode(String.self, forKey: .uid)
        self.sex = try container.decode(String.self, forKey: .uid)
        self.timeLimit = try container.decode(String.self, forKey: .timeLimit)
        self.validity = try container.decode(Bool.self, forKey: .validity)
        self.timer()
    }

    @Published var countDown: String = ""
    
    func timer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.countDown = self.timeLimit.calcTimeLimitmmss()
        }
    }
}

struct AnnSet: Encodable {
    var uid: String
    var sex: String
    var timeLimit: String
    var validity: Bool = true
}
