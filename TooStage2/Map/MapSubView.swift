//
//  MapSecoundSheetView.swift
//  Landmarks
//
//  Created by 田野辺開 on 2021/03/06.
//
import SwiftUI
import CoreLocation

struct MapSubView: View {

    @ObservedObject var shopDetail = ShopDetail.shared
    @StateObject var userData = UserData.shared

    var body: some View {
        VStack {
            
            Text(shopDetail.shop?.name ?? "nil")
                .fontWeight(.bold)
                .font(.title2)
                .padding(.top, 30)
                .padding(.bottom, 10)
            
            /** announce */
            MapSubAnnounceView()
            /** request */
            MapSubRequestView()
            
            NaviMiniDefButtonView(
                text: "このお店での買い物を依頼する",
                processing: shopDetail.shop?.loadItemList ?? non,
                nextView: RequestView()
            )
            .padding(.horizontal, 30)
            .padding(.vertical, 5)
            
            /** アナウンスをしていた場合アナウンスを削除するボタンに変更する予定 */
            FuncMiniBorderButtonView(
                text: "ここにこれから買い物にいく",
                processing: {
                    shopDetail.annRegisterIsOn = true
                })
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            
        }
        .navigationBarHidden(true)
    }
}

extension Text {
    func announce() -> some View {
        self
            .fontWeight(.semibold)
            .font(.subheadline)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity)
            .foregroundColor(Color("color1"))
            .background(Color("yellow1"))
            .cornerRadius(50)
            
    }
}

struct SecondTestView: View {
    var body: some View {
        Text("依頼を実際に引く受ける画面に進みます。")
    }
}
