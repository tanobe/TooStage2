//
//  Shop.swift
//  TooStage2
//
//  
//

import SwiftUI


class Shops: ObservableObject {
    static let shared = Shops()
    @Published var shops = FireStoreGetList<Shop>(collection: "shops")
}

// MARK: - Hub for ContentView
class ShopDetail: ObservableObject {
    
    static let shared = ShopDetail()
    
    // mutable sheet is group
    @Published var isOn: Bool = false
    @Published var offset: CGFloat = UIScreen.main.bounds.height
    
    // hub
    @Published var shop: Shop? = nil
    
    // annouce mini modal sheet group
    @Published var annRegisterIsOn: Bool = false
    @Published var time: Int = 5
    
    @Published var countDown: Int = 0
    
    func showSheet() {
        self.isOn = true
        self.offset = 0
    }
    
    // offset dont have to?
    func dismissSheet() {
        self.isOn = false
        self.offset = UIScreen.main.bounds.height
    }
    
    func shop(_ shop: Shop) {
        self.shop = shop
    }
    
    func annRegister(mm: Int) {
        
        if let sid = shop?.id,
           let uid = UserStatus.shared.uid,
           let sex = UserData.shared.data?.sex {
            
            // documentID
            let aid = Date().dateToSimpleStringFormat() + UserStatus.shared.uid!

            // to Shop Firestore
            let annSet = AnnSet(uid: uid, sex: sex, timeLimit: mmssLaterFromNow(time))
            FirestoreSet(collection: "shops/\(sid)/announce").set(data: annSet, document: aid)
            
            // delete Announce after fiew minutes ago
            let body: [String: Any] = [
                "sid": sid,
                "aid": aid,
                "sex": sex,
                "timeLimit": mm
            ]
            Webhook.shared.post(url: "firebaseModule-triggerAnnounce", body: body)
        }
    }

    // for update
    func annDeletePast() {}
    func annUpdate() {}
    
    func annIsOnFalse() {
        self.annRegisterIsOn = false
        self.time = 5
    }
}


// MARK: - Shop
class Shop: Codable, Identifiable, Equatable, ObservableObject {
    
    static func == (lhs: Shop, rhs: Shop) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    let id: String // sid: shop id
    let name: String
    let subName: String
    let sfSymbol: String
    let postalCode: Int
    let address: String
    let geopoint: [String: Double]
    let shopCategory: String
    let openingHours: [String: [String: Int]]
    let itemCategories: [String]
    
    
    /** stop listening real time if the user transition home screen
     */
    @Published var stopListen: Bool = false
    @Published var requests: GetRequestListInRealTime
    @Published var announce: GetAnnounceListInRealTime
    @Published var items: FirestoreGetItemList<Item>
    
    // load the item list only once like cache
    func loadItemList() {
        if self.items.list == [] {
            print("\n loadItemList()")
            self.items.getDataList()
        }
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case subName
        case sfSymbol
        case postalCode
        case address
        case geopoint
        case shopCategory
        case openingHours
        case itemCategories
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // For property
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.subName = try container.decode(String.self, forKey: .subName)
        self.sfSymbol = try container.decode(String.self, forKey: .sfSymbol)
        self.postalCode = try container.decode(Int.self, forKey: .postalCode)
        self.address = try container.decode(String.self, forKey: .address)
        self.geopoint = try container.decode([String: Double].self, forKey: .geopoint)
        self.shopCategory = try container.decode(String.self, forKey: .shopCategory)
        self.openingHours = try container.decode([String: [String: Int]].self, forKey: .openingHours)
        self.itemCategories = try container.decode([String].self, forKey: .itemCategories)
        
        self.requests = GetRequestListInRealTime(collection: "shops/\(self.id)/requests")
        self.announce = GetAnnounceListInRealTime(collection: "shops/\(self.id)/announce")
        self.items = FirestoreGetItemList<Item>(collection: "shops/\(self.id)/items")
        
        // initialize in here
        self.requests.getListInRealTimeRequest()
        self.announce.getListInRealTimeAnnounce()
    }
}


