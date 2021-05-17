//
//  MatchReqEvaluateView.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/02.
//

import SwiftUI

//MARK: - MatchReqConfirmFourthView
struct MatchReqConfirmFourthView: View {
    var body: some View {
        VStack {
            
            Image("Shopping")
                .padding(.bottom)
                .id("topID")
            Text("お届けが完了しました！")
                .fontWeight(.bold)
                .font(.title3)
                .padding(.bottom, 5)
            ReqStateTextFourthView()
            ReqCircleImageFourthView()
            MatchReqCheckReceiptButtonView()
        }
    }
}


//MARK: - StateTextFourth
struct ReqStateTextFourthView: View {
    var body: some View {
        Text("商品と金額の確認を行なって、\n支払いと評価をお願いします。")
            .stateText()
            .padding(.bottom)
    }
}


//MARK: - MatchReqCheckReceiptButtonView

struct MatchReqCheckReceiptButtonView: View {
    @StateObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    var body: some View {
        VStack {
            Button(action: {
                shared.reciptIsOn = true
            }, label: {
                VStack(alignment: .leading, spacing: 5) {
                
                    if matching.data!.reqUserData.confirmedItemsAndFee.done {
                        HStack(spacing: 5) {

                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color("color2"))
                            
                            Text("届いたレシートを確認しました")
                                .fontWeight(.semibold)
                                .font(.callout)
                        }
                        .padding(.vertical, 12)
                    } else {
                        HStack(spacing: 5) {
                            
                            Text("届いたレシートを確認")
                                .fontWeight(.semibold)
                                .font(.callout)
                        }
                        .padding(.top, 12)
                        Text("必ず商品と金額に間違いがないか確認してください。")
                            .font(.caption)
                            .padding(.bottom, 12)
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
                .background(Color("yellow2"))
                .cornerRadius(5)
                .shadow1(radius: 5)
                .padding(.horizontal)
                .padding(.bottom)
            })
            if !matching.data!.reqUserData.confirmedItemsAndFee.done {
                AnnotationRedView(text: "レシートの内容や届いた商品と金額が異なる場合には、チャットで配達してくれた人と相談して最終的な送金金額を合意してから送金してください。")
                    .padding(.horizontal)
            }
        }
        
    }
}


//MARK: - CircleImageFourth

struct ReqCircleImageFourthView: View {
    
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
                .EllipseColor(Color("yellow2"))
            Rectangle()
                .RectangleColor(Color("yellow2"))
            
            // MARK: - The fourth circle and bar
            Rectangle()
                .RectangleColor(Color("yellow2"))
            Ellipse()
                .EllipseColor(Color(self.light.isOn ? "yellow2" : "gray4"))
        }
        .padding(.top)
        .padding(.bottom, 40)
    }
}
