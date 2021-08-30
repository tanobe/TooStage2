//
//  CartItemView.swift
//  TooStage2
//
// 
//

import SwiftUI

struct CartItemView: View {
    @StateObject var itemDetail = ItemDetail.shared
    @StateObject var cart = Cart.shared
    var item: Item

    var body: some View {
        HStack(spacing: 10) {
            HStack {
                item.image
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 4.5, height: UIScreen.main.bounds.width / 4.5)
                    .cornerRadius(10)
                
            }
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(item.name)
                        .fontWeight(.semibold)
                        .font(.title3)
                    Text("\(item.value)円")
                        .fontWeight(.bold)
                        .font(.footnote)
                    Spacer()
                    HStack {
                        Text("個数")
                            .fontWeight(.bold)
                            .font(.footnote)
                            .foregroundColor(Color("gray1"))
                        Text(String(item.mutableQuantity))
                            .fontWeight(.bold)
                            .font(.body)
                    }
                }
                
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    Button(action: {
                        itemDetail.selectItemForAdd(item: self.item)
                    }) {
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundColor(Color("color1"))
                    }
                        
                    Spacer()
                    HStack {
                        Text("合計")
                            .item()
                        Text("\(item.value * item.mutableQuantity)円")
                            .itemRes()
                    }
                }
                
            }
            .frame(height: UIScreen.main.bounds.width / 4.5)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(5)
        .shadow1(radius: 5)
        .padding(.horizontal)
    }
}

struct ItemView: View {
    
    @ObservedObject var item: Item

    var body: some View {
        HStack(spacing: 10) {
            HStack {
                item.image
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 4.5, height: UIScreen.main.bounds.width / 4.5)
                    .cornerRadius(10)
                
            }
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(item.name)
                        .fontWeight(.semibold)
                        .font(.title3)
                    Text("\(item.value)円")
                        .fontWeight(.bold)
                        .font(.footnote)
                    Spacer()
                    HStack {
                        Text("個数")
                            .fontWeight(.bold)
                            .font(.footnote)
                            .foregroundColor(Color("gray1"))
                        Text(item.quantity!)
                            .fontWeight(.bold)
                            .font(.body)
                    }
                }
                
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                        
                    Spacer()
                    HStack {
                        Text("合計")
                            .item()
                        Text("\(item.value * Int(item.quantity!)!)円")
                            .itemRes()
                    }
                }
                
            }
            .frame(height: UIScreen.main.bounds.width / 4.5)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(5)
        .shadow1(radius: 5)
        .padding(.horizontal)
    }
}
