//
//  TitleView.swift
//  TooStage2
//
//  
//

import SwiftUI

// MARK: - Title

struct RequestSubTitleView: View {
    var subTitle: String
    var body: some View {
        Text(subTitle)
            .fontWeight(.black)
            .font(.callout)
            .foregroundColor(Color("color2"))
            .padding(.leading)
    }
}

struct TitleWithCartView: View {
    @Binding var present: PresentationMode
    @StateObject var cart = Cart.shared
    var title: String
    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Button {
                    if cart.itemList != [] {
                        cart.canIRemoveMiniModal = true
                    } else {
                        self.present.dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(Font.title2.weight(.bold))
                        .foregroundColor(Color("color1"))

                }

                
                
                Spacer()
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("color1"))
                
                Spacer()
                VStack(alignment: .trailing) {
                    
                    ZStack {
                        NavigationLink(destination: CartView()) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "bag.fill")
                                    .font(.title2)
                                    .foregroundColor(Color("color1"))
                                    .padding(.trailing, 3)
                                if cart.itemList.count != 0 {
                                    Image(systemName: "circle.fill")
                                        .font(.caption2)
                                        .foregroundColor(Color("yellow1"))
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 30)
        }
        
        
        
    }
}
