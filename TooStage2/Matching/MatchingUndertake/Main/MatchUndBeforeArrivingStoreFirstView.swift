//
//  MatchUnderBeforeArrivingStoreFirstView.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/12.
//

import SwiftUI

struct MatchUndBeforeArrivingStoreFirstView: View {
    @StateObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    
    var body: some View {
        VStack {
            MatchingTitleView(title: "買い物報告画面")
            ScrollView {
                VStack(alignment: .leading) {
                    if let matching = matching.data {
                        VStack {
                            MatchUnderNowStatusView(title: "お店に向かっています")
                                .padding(.horizontal)

                            ItemizationView(title: "買い物先", text: matching.request.shopName)
                                .padding(.leading)
                                .padding(.top, -5)
                        }
                            .padding(.bottom, 45)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("お店に到着したら次へ切り替え")
                                .matchUndSubText()
                                .padding(.leading)
                            MatchUnderNextActionView(subTitle: "買い物リストのチェック")
                                .padding(.horizontal)
                        }
                            .padding(.bottom, 20)
                        
                        VStack {
                            MatchUnderUserStatusImageView1()
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
                            
                            ItemizationView(title: "買い物先", text: matching.request.shopName)
                                .padding(.leading)

                            MatchUndItemsListView()
                                .padding(.top, 20)
                            
                            MatchUndDescriptions()
                                .padding(.top, 20)
                            
                            MatchCancelButton()
                                .padding(.top, 20)
                        }
                    }
                }
            }
            FuncButtonView(text: "お店に到着した",
                           processing: {
                            self.shared.underArrivingStoreIsOn = true
                           })
                .padding(.bottom, 30)
        }
    }
}


//MARK: - MatchUnderUserStatusImageView
struct MatchUnderUserStatusImageView1: View {
    
    @ObservedObject var light = Spotlight.shared
    
    var body: some View {

        HStack(alignment: .center, spacing: 14) {
            VStack(spacing: 0) {
                //MARK: - First
                Ellipse()
                    .fill(Color(self.light.isOn ? "yellow2" : "gray4"))
                    .frame(width: 23.04, height: 23.04)
                Rectangle()
                    .fill(Color("gray4"))
                    .frame(width: 3, height: 10.5, alignment: .leading)
                //MARK: - Second
                Rectangle()
                    .fill(Color("gray4"))
                    .frame(width: 3, height: 10.5, alignment: .leading)
                Ellipse()
                    .fill(Color("gray4"))
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
                    .fontWeight(.bold)
                    .font(.callout)
                    .foregroundColor(Color("color2"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("買い物をする")
                    .fontWeight(.bold)
                    .font(.callout)
                    .foregroundColor(Color("gray4"))
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
