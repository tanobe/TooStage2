//
//  RequestView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/02/28.
//

import SwiftUI


// MARK: - Content
struct RequestView: View {
    
    /* declare it together. */
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var shopDetail = ShopDetail.shared
    @StateObject var itemDetail = ItemDetail.shared
    @StateObject var cart = Cart.shared
    
    func backToBeforeView() {
        self.cart.removeAll()
        self.presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        ZStack {
            VStack {
                TitleWithCartView(present: presentationMode, title: "\(shopDetail.shop?.name ?? "NaN") 商品一覧")
//                ToggleInformationCartIsUpdatedView()
                RequestCategoryGroupView()
                RequestItemGroupView()
                NaviButtonView(text: "カートに進む", nextView: CartView(), color: !cart.itemList.isEmpty ? "color1" : "color1-1")
            }
            .navigationBarHidden(true)
            .background(Color("background").ignoresSafeArea())
            
        }
        /* declare it together. */
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
        .modalSheet(isPresented: $itemDetail.isOn) {
            ItemDetailAddView(item: itemDetail.item!)
        }

        .modalSheet(isPresented: $cart.canIRemoveMiniModal) {
            MiniModalTwoChoicesView(
                text: "カートが空にになりますがよろしいでしょうか？",
                leftButton: FuncMiniBorderButtonView(
                    text: "キャンセル",
                    processing: {cart.canIRemoveMiniModal = false}),
                rightButton: FuncMiniButtonView(
                    text: "はい",
                    processing: backToBeforeView)
            )
        }
        .modalSheet(isPresented: $cart.justIn, backTapDismiss: false) {
            TellShortMessageView(text: "カートに追加しました")
        }
        .animation(.easeInOut)
        
    }
}
