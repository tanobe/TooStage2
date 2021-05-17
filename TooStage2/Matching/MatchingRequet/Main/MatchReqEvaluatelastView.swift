//
//  SwiftUIView.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/05.
//

import SwiftUI

//MARK: - MatchReqEvaluatelastView
struct MatchReqEvaluatelastView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var matching = MatchingDataClass.shared.matching
    @StateObject var shared = MatchingDataClass.shared
    @StateObject var userData = UserData.shared
    
    @StateObject var payAccount = PaymentStatus.shared
    @StateObject var checkoutFlag = CheckoutFlag.shared
    
    let checkout = CheckoutWithStripe()
    
    init() {
        guard let undData = matching.data?.undUserData,
              let matching = self.matching.data else {
            fatalError()
        }
        self.checkout.startCheckout(totalExaAmount: matching.totalExaAmount, exaFee: matching.exaFee, suid: undData.suid)
    }
    
    var body: some View {
        VStack {
            TitleView(present: presentationMode, title: "お支払いと評価")
            ScrollView {
                VStack(alignment: .leading) {
                    if let matching = matching.data {
                        VStack(spacing: 15) {
                            Text("支払合計金額")
                                .subTitle()
                                .padding(.leading)
                            Text("\(matching.totalExaAmount)円")
                                .fontWeight(.bold)
                                .font(.largeTitle)
                                .padding(.leading)
                        }
                        .padding(.top, 20)
                        
                        
                        MatchingEvaluateView()
                            .padding(.top, 20)
                            .padding(.bottom, 5)

                        
                        VStack {
                            HStack {
                                Text("ご依頼の詳細")
                                    .subTitle()
                                Spacer()
                            }
                            .padding(.leading)
                            .padding(.top, 30)
                            
                            ItemizationView(title: "買い物先", text: matching.request.shopName)
                                .padding(.leading)
                            
                            MatchReqItemsListView()
                            .padding(.top, 15)
                            
                            MatchReqDescriptionsView()
                                .padding(.top, -10)
                                .padding(.bottom, 10)
                        }
                        
                        
                    }
                }
            }
            MatchReqFinishedButtonView()
                .padding(.bottom, 30)
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
        .edgesIgnoringSafeArea(.bottom)
        .modalSheet(isPresented: $payAccount.regPayModal, backTapDismiss: false) {
            UpdateCreditCardView(isOn: $payAccount.regPayModal)
        }
        .modalSheet(isPresented: $shared.comopletedIsOn, backTapDismiss: false) {
            MiniModalTwoChoicesMatchingView(
                text: "取引を完了します",
                subText: "完了後の修正はできません",
                leftButton: FuncMiniBorderButtonView(
                    text: "戻る",
                    processing: {
                        self.shared.comopletedIsOn = false
                    }),
                rightButton: FuncMiniButtonView(
                    text: "完了",
                    processing: {
                        self.shared.loading = true
                        guard let card = userData.data?.card else {
                            fatalError()
                        }
                        checkout.payAndSetData(card: card)
                    })
            )
        }
        .alert(isPresented: $checkoutFlag.canceled) {
            Alert(title: Text("支払いが認められませんでした"), message: Text("もう一度試す、または別のクレジットカードに変更してください"), dismissButton: .default(Text("はい")))
        }
        .alert(isPresented: $checkoutFlag.failed) {
            Alert(title: Text("支払いが認められませんでした"), message: Text("もう一度試す、または別のクレジットカードに変更してください"), dismissButton: .default(Text("はい")))
        }
        .loading(isPresented: $shared.loading)
        .modalSheet(isPresented: $shared.thanksIsOn, backTapDismiss: false) {
            ThankYouForReqMatchingView(isOn: $shared.thanksIsOn)
        }
        .animation(.easeInOut)
    }
}


//MARK: - MatchReqCompletedAndFinishedButton

struct MatchReqFinishedButtonView: View {
    @ObservedObject var matching = MatchingDataClass.shared.matching
    @StateObject var shared = MatchingDataClass.shared
    var body: some View {
        FuncButtonView(
            text: "送金して取引を完了",
            processing: {
                
                self.shared.comopletedIsOn = true
                if let matching = matching.data {
                    // notif
                    let notif: [String: Any] = [
                        "fmcToken": matching.undUserData.fmcToken,
                        "title": "依頼者が送金しました！",
                        "body": "最後に相手の評価をお願いいます。"
                    ]
                    Webhook.shared.post(url: "notification", body: notif)
                }
            })
    }
}

struct ThankYouForReqMatchingView: View {
    
    @Binding var isOn: Bool
    
    var body: some View {
        VStack {
            Image("Smiling")
                .resizable()
                .frame(width: 180, height: 180)
                .padding(.bottom)
            
            VStack(alignment: .center, spacing: 5) {
                Text("ご利用ありがとうございました。")
                    .head()
                Text("今度はついでに買い物に行ってみてくださいね！")
                    .font(.footnote)
            }
            .padding(.bottom)
            
            FuncMiniButtonView(text: "ホーム画面に戻る", processing: {
                MatchingDataClass.shared.comopletedIsOn = false
                isOn = false
                let data: [String: Any] = ["matchingId": ""]
                UserData.shared.updateDocument(data: data)
                MatchingDataClass.shared.initAll()
            })
            .padding(.horizontal, 30)
        }
        .padding(30)
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(10)
    
    }
}
