//
//  ItemView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/09.
//

import SwiftUI

// MARK: - Item


struct RequestItemView: View {
    
    var sw = UIScreen.main.bounds.size.width
    // to be StateObject
    @ObservedObject var item: Item
    @StateObject var itemDetail = ItemDetail.shared

    init(item: Item) {
        self.item = item
        item.loadImage()
    }

// MARK: - Body
    var body: some View {
        ZStack {
            Button(action: {
                // set detail view's value
                itemDetail.selectItemForAdd(item: self.item)
            }, label: {
                VStack(alignment: .leading, spacing: 0) {

                    item.image
                        .resizable()
                        .scaledToFill()
                        .frame(width: sw / 2.5, height: sw / 3.75)
                        .clipped()
                        .cornerRadius(5)
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .padding(.top, 5)
                            .foregroundColor(.black)
                        Text("\(item.value) 円")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(5)
                .shadow1(radius: 5)
            })
        }
        
    }
}

struct RequestItemScrollView: View {
    
    @StateObject var items = ShopDetail.shared.shop!.items
    

    var columns = Array(repeating: GridItem(), count: 2)
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView(.vertical) {
                VStack {
                    
                    LazyVGrid(columns: columns, spacing: 7) {
                        // filter by category
                        ForEach(items.category == "すべて" ? items.list : items.list.filter({ $0.category == items.category})) { item in

                            RequestItemView(item: item)
                            
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom)
            }
        }
    }
}

struct RequestItemGroupView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RequestSubTitleView(subTitle: "Items")
                .padding(.bottom, 10)
            RequestItemScrollView()
        }
        .padding(.top, 10)
    }
}
