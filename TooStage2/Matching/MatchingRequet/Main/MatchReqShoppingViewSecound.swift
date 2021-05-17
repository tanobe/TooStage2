//
//  MatchReqSecoundView.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/01.
//

import SwiftUI

//MARK: - MatchReqShoppingSecondView
struct MatchReqShoppingSecondView: View {
    var body: some View {
        VStack {
            Image("Shopping")
                .padding(.bottom)
            ReqStateTextSecondView()
            ReqCircleImageSecondView()
        }
    }
}

struct ReqStateTextSecondView: View {
    var body: some View {
        Text("お店で買い物をしてくれています。\n買えたものは依頼詳細から確認できます。")
            .stateText()
            .padding(.bottom)
    }
}

// MARK: - CircleImageSecond

struct ReqCircleImageSecondView: View {
    
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
                .EllipseColor(Color(self.light.isOn ? "yellow2" : "gray4"))
            Rectangle()
                .RectangleColor(Color("gray4"))
            
            // MARK: - The third circle and bar
            Rectangle()
                .RectangleColor(Color("gray4"))
            Ellipse()
                .EllipseColor(Color("gray4"))
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
