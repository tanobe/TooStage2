//
//  ItemDetailView.swift
//  TooStage2
//
// 
//

import SwiftUI
// MARK: - Dissmiss
struct DismissView: View {
    @Binding var modal: Bool
    var body: some View {
        HStack(alignment: .bottom) {
            Spacer()
            Button(action: {
                modal = false
            }, label: {
                Image(systemName: "multiply")
                    .foregroundColor(Color( "color1"))
                    .font(.title2)
                    .frame(width: 30, height: 30, alignment: .trailing)
            })
        }
        .padding(.bottom, 10)
    }
}

// MARK: - Introduction
struct ItemIntroductionView: View {
    var item: Item
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 5) {
                item.image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipped()
                    .cornerRadius(10)
                    
                Text(item.name)
                    .fontWeight(.semibold)
                    .font(.title3)
                    .padding(.top, 10)

                Text("\(item.value) 円")
                    .fontWeight(.bold)
                    .font(.caption)
            }
            .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(item.subName)
                    .font(.subheadline)
                Text(item.suplier ?? "")
                    .font(.subheadline)
            }
        }
        .padding(.bottom, 10)
    }
}


// MARK: - Amount
struct SelectItemQuantityView: View {
    @Binding var count: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("個数")
                    .fontWeight(.bold)
                    .font(.caption)
                    .foregroundColor(Color("gray1"))
                
                VStack {
                    Text(String(count))
                    .fontWeight(.bold)
                    .font(.callout)
                    .lineSpacing(20)
                }
                
            }
            
            HStack(alignment: .center) {
                ForEach(1..<4) { num in
                    Button(action: {
                        count = num
                    }, label: {
                        if count == num {
                            Text(String(num))
                                .countIsOn()
                        } else {
                            Text(String(num))
                                .countIsNotOn()
                        }
                    })
                }
            }
            .padding(.bottom)
            .frame(maxWidth: .infinity)
        }
        .padding(.bottom, 10)
    }
}

// MARK: - Result

struct ItemDetailAddView: View {
    @StateObject var item: Item
    @StateObject var itemDetail = ItemDetail.shared
    @StateObject var cart = Cart.shared
    @State var count: Int = 1

    var body: some View {
        VStack {
            DismissView(modal: $itemDetail.isOn)
            ItemIntroductionView(item: item)
            SelectItemQuantityView(count: $count)
            FuncButtonView(text: "カートに入れる") { cart.addToCart(item: self.item, count: self.count)
                self.itemDetail.dismissForAdd()
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical)
        .frame(width: 300)
        .background(Color(.white))
        .cornerRadius(10)
    }
}

struct ItemDetailUpdateView: View {
    @StateObject var item: Item
    @StateObject var itemDetail = ItemDetail.shared
    @StateObject var cart = Cart.shared
    @State var count = 1

    var body: some View {
        VStack {
            DismissView(modal: $itemDetail.isOnUpdate)
            ItemIntroductionView(item: item)
            SelectItemQuantityView(count: $count)
            FuncButtonView(text: "修正") { cart.updateItem(item: self.item, count: self.count)
                self.itemDetail.dismissForUpdate()
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical)
        .frame(width: 300)
        .background(Color(.white))
        .cornerRadius(10)
    }
}

struct ItemDetailView: View {
    @StateObject var itemDetail = ItemDetail.shared
    var body: some View {
        VStack {
            DismissView(modal: $itemDetail.isOn)
            ItemIntroductionView(item: itemDetail.item!)
                .padding(.bottom, 20)
        }
        .padding(.horizontal, 30)
        .padding(.vertical)
        .frame(width: 300)
        .background(Color(.white))
        .cornerRadius(10)
    }
}




extension Text {
    func countIsOn() -> some View {
        self
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color("color1"))
            .cornerRadius(10)
    }
    
    func countIsNotOn() -> some View {
        self
            .font(.caption)
            .foregroundColor(.black)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color("gray2"))
            .cornerRadius(10)
    }
}
