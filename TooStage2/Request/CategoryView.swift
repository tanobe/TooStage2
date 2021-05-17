//
//  CategoryView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/09.
//

import SwiftUI

func jaToEnAboutCategory(_ ja: String) -> String {
    switch ja {
    case "すべて":
        return "all"
    case "食べ物":
        return "food"
    case "飲み物":
        return "drink"
    case "日用品":
        return "commodity"
    default:
        return "no"
    }
}

struct RequestCategoryView: View {

    var title: String
    @StateObject var storage: FireStorageGet
    @StateObject var items = ShopDetail.shared.shop!.items
    
    init(title: String) {
        self.title = title
        let category = jaToEnAboutCategory(title)
        self._storage = StateObject(wrappedValue: FireStorageGet(url: "/categories/\(category).jpg"))
    }
    
    func countByCategory() -> String {
        if self.title == "すべて" {
            return "\(items.list.count)件の表示"
        } else {
            return "\(items.list.filter( {$0.category == title} ).count)件の表示"
        }
    }

    
    var body: some View {
        HStack{
            self.storage.image
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 35)
                .clipped()
                .cornerRadius(5)
            VStack(alignment: .leading, spacing: 5) {
                Text(self.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(items.category == self.title ? .white : .black)
                
                Text(countByCategory())
                    .font(.caption)
                    .foregroundColor(items.category == self.title ? .white : .black)
            }
        }
        .padding(10)
        .background(items.category == self.title ? Color("color1") : Color.white)
        .cornerRadius(5)
        .shadow1(radius: 5)
        .padding(.vertical)
    }
}

struct RequestCategoryScrollView: View {
    
    // for get category list
    @StateObject var shopDetail = ShopDetail.shared
    @StateObject var items = ShopDetail.shared.shop!.items
    
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top, spacing: 5) {
                Button(action: {
                    items.category = "すべて"
                }, label: {
                    RequestCategoryView(title: "すべて")
                })
                let categories = shopDetail.shop?.itemCategories ?? []
                
                ForEach(0..<categories.count) { i in
                    Button(action: {
                        items.category = categories[i]
                    }, label: {
                        RequestCategoryView(title: categories[i])
                    })
                }
                
            }
            .padding(.horizontal)
        }
    }
}

struct RequestCategoryGroupView: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RequestSubTitleView(subTitle: "Category")
            RequestCategoryScrollView()
        }
//        .padding(.top, 30)
    }
}
