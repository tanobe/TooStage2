//
//  MatchUnderShoppingViewSecond.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/12.
//

import SwiftUI

struct MatchUndShoppingSecondView: View {
    
    @StateObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            MatchingTitleView(title: "買い物報告画面")
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    
                    MatchUnderNowStatusView(title: "買い物中です")
                        .padding(.horizontal)
                    
                    Text("買えた商品にチェックをつけてください")
                        .matchUndSubText()
                        .padding(.leading)
                    
                    MatchUndCheckBuyItemsListView()
                    
                    AnnotationRedView(text: "必ず購入した商品のレシートを受け取ってください")
                        .padding(.leading)
                        .padding(.top, -5)

                    ItemizationView(title: "買い物先", text: matching.data!.request.shopName)
                        .padding(.leading)
                        .padding(.top, -20)
                }
                    .padding(.bottom, 40)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("お会計とレシートの受け取りが完了したら次へ")
                        .matchUndSubText()
                    MatchUnderNextActionView(subTitle: "レシートの確認と送信")
                        
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                VStack {
                   
                    MatchUnderUserStatusImageView2()
                        .padding(.leading)
                    
                    NaviChatButtonView()
                        .padding(.top, 8)
                    
                    AnnotationRedView(text: "到着時間や、買い物に関する変更の必要が出てきた場合などは依頼した人に相談してみましょう")
                        .padding(.horizontal)
                }
                        .padding(.bottom, 20)
                
                VStack {
                    
                    HStack {
                        Text("依頼詳細")
                            .subTitle()
                            .padding(.leading)
                        Spacer()
                    }

                    ItemizationView(title: "買い物先", text: matching.data!.request.shopName)
                        .padding(.leading)
                    
                    MatchUndItemsListView()
                        .padding(.top, 20)
                    
                    MatchUndDescriptions()
                        .padding(.top, 20)
                    
                    MatchCancelButton()
                        .padding(.top, 20)
                    
                }
            }
            FuncButtonView(text: "これから商品を届ける",
                           processing: {
                            self.shared.undDeliveringIsOn = true
                           })
                .padding(.bottom, 30)
        }
        
    }
}


//MARK: - MatchUnderUserStatusImageView2
struct MatchUnderUserStatusImageView2: View {
    
    @ObservedObject var light = Spotlight.shared
    
    var body: some View {

        HStack(alignment: .center, spacing: 14) {
            VStack(spacing: 0) {
                //MARK: - First
                Ellipse()
                    .fill(Color("yellow2"))
                    .frame(width: 23.04, height: 23.04)
                Rectangle()
                    .fill(Color("yellow2"))
                    .frame(width: 3, height: 10.5, alignment: .leading)
                //MARK: - Second
                Rectangle()
                    .fill(Color("yellow2"))
                    .frame(width: 3, height: 10.5, alignment: .leading)
                Ellipse()
                    .fill(Color(self.light.isOn ? "yellow2" : "gray4"))
                    .frame(width: 23.04, height: 23.04)
                Rectangle()
                    .fill(Color("gray4"))
                    .frame(width: 3, height: 10.5, alignment: .leading)

                //MARK: - Thired
                Rectangle()
                    .fill(Color("gray4"))
                    .frame(width: 3, height: 10.5, alignment: .leading)
                Ellipse()
                    .fill(Color("gray4"))
                    .frame(width: 23.04, height: 23.04)
                Rectangle()
                    .fill(Color("gray4"))
                    .frame(width: 3, height: 10.5, alignment: .leading)

                //MARK: - Fourth

                Rectangle()
                    .fill(Color("gray4"))
                    .frame(width: 3, height: 10.5, alignment: .leading)
                Ellipse()
                    .fill(Color("gray4"))
                    .frame(width: 23.04, height: 23.04)
            }

            VStack(spacing: 24) {
                Text("買い物先へ移動")
                    .font(.callout)
                    .foregroundColor(Color("color2"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("買い物をする")
                    .fontWeight(.bold)
                    .font(.callout)
                    .foregroundColor(Color("color2"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("お届け先に移動")
                    .fontWeight(.bold)
                    .font(.callout)
                    .foregroundColor(Color("gray4"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("配達完了")
                    .fontWeight(.bold)
                    .font(.callout)
                    .foregroundColor(Color("gray4"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .animation(.easeInOut)
    }
}
