//
//  User.swift
//  TooStage2
//
//  
//

import Foundation
import FirebaseFirestore

class UserData: ObservableObject {
    // call user data with UserData.shared.data!.xxx
    static let shared = GetDocumentInRealTime<User>(collection: "users")
}

struct BirthDay: Codable {
    var year: String
    var month: String
    var day: String
}

class User: Codable {

    var id: String
    var regTime: String
    var email: String
    var familyName: String
    var givenName: String
    var sex: String
    var postalCode: Int
    var address1: String
    var address2: String
    var roomNumber: String
    var birthDay: BirthDay
    var requestId: String
    var matchingId: String
    var fmcToken: String
    
    // credit card
    var onboardIs: Bool
    var cardIs: Bool
    var suid: String?
    var card: CreditCard?
    
    var address: String {
        address1 + address2
    }
    
    var addressWithRoomNum: String {
        address + " " + roomNumber + "号室"
    }
}

// for set completeInfo to firestore
struct UserInfo: Codable {
    
    // auth at FirebaseUIView
    var regTime: String = Date().dateToString()
    var email: String
    
    // Edit at NextInfoView
    var familyName: String
    var givenName: String
    var sex: String
    var postalCode: Int
    var address1: String
    var address2: String
    // Depending on the user, the room number may not be a number.
    var roomNumber: String
    var birthday: Date?
    var birthDay: BirthDay
    
    var requestId: String = ""
    var matchingId: String = ""
    
    var fmcToken: String
    
    var onboardIs: Bool = false
    var cardIs: Bool = false
    
    var address: String {
        address1 + address2
    }

}
