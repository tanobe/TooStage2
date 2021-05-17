//
//  Cart.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/11.
//

import SwiftUI

class Cart: ObservableObject {

    static let shared = Cart()
    
    @Published var itemList = [Item]()
    @Published var justIn: Bool = false
    @Published var justUpdate: Bool = false
    
    @Published var memo: String = "" {
        didSet {
            if memo.count > 100 {
                self.memo = String(memo.prefix(100))
            }
        }
    }
    
    @Published var canIRemoveMiniModal = false
    @Published var reward: String = "100"
    @Published var deliveryMethod = "置き配"
    
    var message = "カートに商品が追加されました"
    
    var itemsTotalCount: Int {
        var amount = 0
        for item in itemList {
            amount += item.mutableQuantity
        }
        return amount
    }
    
    var itemsApxAmount: Int {
        var sum = 0
        for item in itemList {
            sum += item.value * item.mutableQuantity
        }
        return sum
    }
    
    var apxFee: Int {
        Int(floor(Double(itemsApxAmount) * 0.01 * 10))
    }
    
    var totalApxAmount: Int {
        itemsApxAmount + apxFee + Int(reward)!
    }
    
    func addToCart(item: Item, count: Int) {
        if item.isInCart {
            for was in itemList {
                if was == item {
                    was.mutableQuantity += count
                }
            }
        } else {
            item.isInCart = true
            item.mutableQuantity = count
            self.itemList.append(item)

        }
        self.justIn = true
        // show 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.justIn = false
        }
    }
    
    func updateItem(item: Item, count: Int) {
        item.mutableQuantity = count
        self.justUpdate = true
        // show 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.justUpdate = false
        }
    }
    
    func deleteItem(item: Item) {
//        itemList.filter({$0 == item}).first?.isInCart = false
//        itemList.filter({$0 == item}).first?.quantity = 1
        
        guard let index = self.itemList.firstIndex(of: item) else { return }
        // delete item from the cart
        item.isInCart = false
        // initialize the item data
        item.mutableQuantity = 1
        self.itemList.remove(at: index)
    }
    
    func removeAll() {
        for item in itemList {
            item.mutableQuantity = 1
            item.isInCart = false
        }
        self.itemList = [Item]()
        self.canIRemoveMiniModal = false
    }
    
}
