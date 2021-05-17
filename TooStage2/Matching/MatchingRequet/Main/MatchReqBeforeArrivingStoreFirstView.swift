//
//  MatchReqBeforeArrivingStoreFirstView.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/02.
//

import SwiftUI

//MARK: - MatchReqBeforeArrivingStoreFirstView
struct MatchReqBeforeArrivingStoreFirstView: View {
    var body: some View {
        VStack {
            Image("Hurrying")
                .padding(.bottom)
            ReqStateTextFirestView()
            ReqCircleImageFirestView()
        }
    }
}

//MARK: - StateTextFirest

struct ReqStateTextFirestView: View {
    var body: some View {
        Text("お店に向かってくれています\nお店に着いて買い物が進むと画面が変わります")
            .stateText()
            .padding(.bottom)
    }
}

//MARK: - CircleImageFirest

struct ReqCircleImageFirestView: View {
    
    @ObservedObject var light = Spotlight.shared
    
    var body: some View {
        HStack(alignment: .center, spacing: 0){
            
            // MARK: -　The first circle and bar
            Ellipse()
                .EllipseColor(Color(self.light.isOn ? "yellow2" : "gray4"))
            Rectangle()
                .RectangleColor(Color("gray4"))
            
            // MARK: -　The second circle and bar
            Rectangle()
                .RectangleColor(Color("gray4"))
            Ellipse()
                .EllipseColor(Color("gray4"))
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
