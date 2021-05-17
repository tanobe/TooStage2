//
//  MatchingReqReceiptConfirmView.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/02.
//

import SwiftUI

//MARK: - MatchReqCarryGoodsThiredView
struct MatchReqCarryGoodsThiredView: View {
    var body: some View {
        VStack {
            Image("Shopping")
                .padding(.bottom)
            Text("現在お届けに向かっています。")
                .fontWeight(.bold)
                .font(.title3)     
            ReqStateTextThiredView()
            ReqCircleImageThiredView()
        }
    }
}


//MARK: - StateTextThired
struct ReqStateTextThiredView: View {
    var body: some View {
        Text("レシートと商品の確認ができたら\n送金に移ります。")
            .stateText()
            .padding(.bottom)
    }
}



//MARK: - CircleImageThired
struct ReqCircleImageThiredView: View {
    
    @ObservedObject var light = Spotlight.shared
    
    var body: some View {
        HStack(alignment: .center, spacing: 0){
            
            // MARK: -　The first circle and bar
            Ellipse()
                .EllipseColor(Color("yellow2"))
            Rectangle()
                .RectangleColor(Color("yellow2"))
            
            // MARK: -　The second circle and bar
            Rectangle()
                .RectangleColor(Color("yellow2"))
            Ellipse()
                .EllipseColor(Color("yellow2"))
            Rectangle()
                .RectangleColor(Color("yellow2"))
            
            // MARK: - The third circle and bar
            Rectangle()
                .RectangleColor(Color("yellow2"))
            Ellipse()
                .EllipseColor(Color(self.light.isOn ? "yellow2" : "gray4"))
            Rectangle()
                .RectangleColor(Color("gray4"))
            
            // MARK: - The fourth circle and bar
            Rectangle()
                .RectangleColor(Color("gray4"))
            Ellipse()
                .EllipseColor(Color("gray4"))
            
        }
        .padding(.top)
        .padding(.bottom, 40)
    }
}
