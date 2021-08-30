//
//  ItemDetail.swift
//  TooStage2
//
// 
//

import SwiftUI

class ItemDetail: ObservableObject {
    
    static let shared = ItemDetail()
    
    @Published var isOn: Bool = false
    @Published var item: Item? = nil
    @Published var isOnUpdate: Bool = false
    func selectItemForAdd(item: Item) {
        self.item = item
        self.isOn = true
    }
    func selectItemForUpdate(item: Item) {
        self.item = item
        self.isOnUpdate = true
    }
    func dismissForAdd() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isOn = false
        }
    }
    func dismissForUpdate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isOnUpdate = false
        }
    }
}
