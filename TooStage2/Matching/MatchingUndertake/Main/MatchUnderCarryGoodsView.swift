//
//  MatchUnderCarryGoodsThiredView.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/12.
//

import SwiftUI

struct MatchUndCarryGoodsView: View {

    
    @Environment(\.presentationMode) private var presentationMode

    @StateObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleView(present: presentationMode, title: "買い物報告画面")
            ScrollView {
                if let matching = matching.data {
                    VStack {
                        
                        MatchUnderNowStatusView(title: "お届け中です")
                            .padding(.horizontal)
                        
                        ItemizationView(title: "お届け先", text: matching.request.deliveryAddress)
                            .padding(.leading)
                        
                        ItemizationView(title: "配達先　", text: matching.request.deliveryMethod)
                            .padding(.horizontal)
                    }
                        .padding(.bottom, 50)
                    
                    VStack(alignment: .leading) {
                        Text("お届けが完了したら次へ")
                            .matchUndSubText()
                            .padding(.leading)
                            .padding(.bottom, 20)
                        MatchUnderNextActionView(subTitle: "送金の確認と評価")
                            .padding(.horizontal)
                    }
                        .padding(.bottom, 20)
                    
                    MatchUnderUserStatusImageView3()
                        .padding(.leading)
                    
                    VStack {
                        
                        NaviChatButtonView()
                        
                        AnnotationRedView(text: "到着時間や、買い物に関する変更の必要が出てきた場合などは依頼した人に相談してみましょう")
                            .padding(.horizontal)
                        
                        AnnotationRedView(text: "合計金額に誤りがある場合は前の画面に戻り、適切な金額を入力し直してください")
                            .padding(.horizontal)
                    }
                        .padding(.bottom, 20)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("依頼詳細")
                                .subTitle()
                                .padding(.leading)
                            Spacer()
                        }
                        
                        ItemizationView(title: "買い物先　　", text: matching.request.shopName)
                            .padding(.leading)
                            .padding(.bottom, 20)
                        
                        MatchReqItemsListView()
                        
                        MatchUndDescriptions()
                            .padding(.vertical, 20)
                        
                        MatchUndReceivedAmount()
                        
                        MatchCancelButton()
                            .padding(.top, 20)
                    }
                }
                
            }
            FuncButtonView(
                text: "商品を届けた",
                processing: {
                    if let matching = matching.data {
                        self.matching.setDocument(doc: UserData.shared.data!.matchingId) {
                            self.matching.data?.undUserData.deliveried = shared.setTimeAndBool()
                            self.shared.undDeliveringIsOn = false
                        }
                        let notif: [String: Any] = [
                            "fmcToken": matching.request.fmcToken,
                            "title": "商品が届きました！",
                            "body": "相手への評価と送金をお願いします。"
                        ]
                        Webhook.shared.post(url: "notification", body: notif)
                    }
                }
            )
            .padding(.bottom, 30)
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
        .edgesIgnoringSafeArea(.bottom)
        .modalSheet(isPresented: $shared.cancelIsOn) {
            MiniModalTwoChoicesMatchingView(
                text: "依頼のキャンセル申請を\n送りますか？",
                subText: " キャンセルの成立には双方が申請を送る必要があります。相手も申請するまでは取引が継続し、商品到着後は支払いが発生します。",
                annotation: "双方がキャンセルを申請すると取引中止が成立します。",
                leftButton: FuncMiniBorderButtonView(text: "戻る", processing: {
                    self.shared.cancelIsOn = false
                }),
                rightButton: FuncMiniButtonView(text: "申請", processing: {
                    self.shared.cancel()
                    self.shared.cancelIsOn = false
                })
            )
        }
        .modalSheet(isPresented: $shared.cancelOneSide) {
            MiniModalOneButtonView(
                text: "キャンセル申請を受付けました。",
                annotation: "双方のキャンセルが成立した場合、一切の料金は発生しません。\nまた、取引は予告なく終了し、ホーム画面に戻ります。",
                button: FuncMiniButtonView(
                    text: "閉じる",
                    processing: {
                        shared.cancelOneSide = false
                }),
                isOn: $shared.cancelOneSide)
        }
        .modalSheet(isPresented: $shared.cancelBothSides, backTapDismiss: false) {
            MiniModalOneButtonView(
                text: "双方のキャンセルが成立しました。",
                annotation: "ご利用ありがとうございました。",
                button: FuncMiniButtonView(
                    text: "ホームに戻る",
                    processing: {
                        shared.cancelBothSides = false
                        if let mdata = matching.data {
                            
                            Webhook.shared.post(
                                url: "cancelTransaction",
                                body: [
                                "reqUid": matching.data!.reqUserData.uid,
                                "undUid": matching.data!.undUserData.uid
                                ]
                            )
                            
                            // history req
                            FirestoreSet(collection: "users/\(matching.data!.reqUserData.uid)/matchingHistories").set(data: mdata, document: mdata.id)

                            // history und
                            FirestoreSet(collection: "users/\(matching.data!.undUserData.uid)/matchingHistories").set(data: mdata, document: mdata.id)
                        }
                }),
                isOn: $shared.cancelBothSides)
        }
    }
}



//MARK: - MatchUnderUserStatusImageView3
struct MatchUnderUserStatusImageView3: View {
    
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
                    .fill(Color("yellow2"))
                    .frame(width: 23.04, height: 23.04)
                Rectangle()
                    .fill(Color("yellow2"))
                    .frame(width: 3, height: 10.5, alignment: .leading)

                //MARK: - Thired
                Rectangle()
                    .fill(Color("yellow2"))
                    .frame(width: 3, height: 10.5, alignment: .leading)
                Ellipse()
                    .fill(Color(self.light.isOn ? "yellow2" : "gray4"))
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
                    .font(.callout)
                    .foregroundColor(Color("color2"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("お届け先に移動")
                    .fontWeight(.bold)
                    .font(.callout)
                    .foregroundColor(Color("color2"))
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

