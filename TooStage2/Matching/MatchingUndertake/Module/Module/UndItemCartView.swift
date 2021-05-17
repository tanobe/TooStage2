//
//  UndItemCartView.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/17.
//

import SwiftUI

//MARK: - MatchUndItemsListView
struct MatchUndItemsListView: View {
    @ObservedObject var matching = MatchingDataClass.shared.matching
    var body: some View {
        VStack {
            if let matching = matching.data {
                ForEach(matching.request.cart) { item in
                    MatchUndCheckItemView(item: item)
                }
            }
        }
    }
}

//MARK: - MatchUndCheckItemView
struct MatchUndCheckItemView: View {

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
                VStack(alignment: .trailing) {


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

//MARK: - MatchUndItemsListView
struct MatchUndCheckBuyItemsListView: View {
    @ObservedObject var matching = MatchingDataClass.shared.matching
    var body: some View {
        VStack {
            ForEach(matching.data?.request.cart ?? []) { item in
                MatchUndCheckBuyItemView(item: item)
            }
        }
    }
}

//MARK: - MatchUndCheckBuyItemView
struct MatchUndCheckBuyItemView: View {
    @StateObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    
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
                    Button(action: {
                            self.matching.setDocument(doc: UserData.shared.data!.matchingId) {
                                if item.bought! {
                                    self.matching.data?.request.cart.filter({$0 == item}).first?.bought = false
                                } else {
                                    self.matching.data?.request.cart.filter({$0 == item}).first?.bought = true
                                }
                        }
                        
                    }, label: {
                        if item.bought! {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                                .foregroundColor(Color("color1"))
                        } else {
                            Image(systemName: "circle")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                    })
                    
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
