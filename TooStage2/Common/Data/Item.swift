//
//  Item.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/11.
//

import SwiftUI

class Item: Codable, Identifiable, Equatable, ObservableObject {
    
    // comform to Equatable protocol
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.bought == rhs.bought
    }

    let id: String // iid
    let category: String
    let name: String
    let value: Int
    let imageUrl: String
    let subName: String
    let suplier: String?
    
    // for set request
    var quantity: String?
    
    // for update document in matching view
    var bought: Bool?
    
    enum CodingKeys: CodingKey {
        case id
        case category
        case name
        case value
        case imageUrl
        case subName
        case suplier
        case quantity
        case bought
    }
    
    // MARK: - For Cart
    @Published var mutableQuantity: Int = 1 {
        didSet {
            self.quantity = String(mutableQuantity)
        }
    }
    @Published var isInCart: Bool = false
    @Published var image: Image = Image("noImage")
    
    // MARK: - For Matching
    @Published var mutableBought: Bool = false {
        didSet {
            self.bought = mutableBought
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.category = try container.decode(String.self, forKey: .category)
        self.name = try container.decode(String.self, forKey: .name)
        self.value = try container.decode(Int.self, forKey: .value)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.subName = try container.decode(String.self, forKey: .subName)
        self.suplier = try container.decodeIfPresent(String.self, forKey: .suplier)
        self.quantity = try container.decodeIfPresent(String.self, forKey: .quantity)
        self.bought = try container.decodeIfPresent(Bool.self, forKey: .bought)
    }
    
    func loadImage() {
        // Viewが再描画された時に読み込みを防ぐ
        if self.image == Image("noImage") {
            FireStorageGetEsc.shared.get(url: imageUrl) { image in
                DispatchQueue.main.async {
                    self.image = image
                    print("\n not noImage")
                }
            }
        }
    }
    
    deinit {
        print("deinit item class")
    }

}
