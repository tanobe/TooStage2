//
//  Matching.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/03/24.
//

import SwiftUI

//MARK: - MatchingRequestView
struct MatchingRequestView: View {
    
    @StateObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    @StateObject var sendMail = WebhookSendMail()
    
    init() {
        self.matching.getDocument(doc: UserData.shared.data!.matchingId)
    }
    
    
    var body: some View {

        VStack {
            MatchingTitleView(title: "配達の状況")
            ScrollViewReader { proxy in
                // for scroll view back to top
                ScrollView {
                    
                    VStack(spacing: 12) {
                        
                        switch shared.judgeReqStatus() {
                        case .first:
                            MatchReqBeforeArrivingStoreFirstView()
                        case .second:
                            MatchReqShoppingSecondView()
                        case .thired:
                            MatchReqCarryGoodsThiredView()
                        case .fourth:
                            MatchReqConfirmFourthView()
                                .onAppear {
                                    withAnimation {
                                        proxy.scrollTo("topID")
                                    }
                                }
                        }
                        
                        NaviChatButtonView()
                        
                        HStack {
                            Text("ご依頼の詳細")
                                .subTitle()
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.top)
                        ItemizationView(title: "買い物先", text: matching.data?.request.shopName ?? "")
                            .padding(.leading)
                        
                        MatchReqItemsListView()
                        .padding(.top, 15)

                        switch shared.judgeReqStatus() {
                        case .first, .second, .thired:
                            MatchReqDescriptionsForUpToThirdView()
                            MatchCancelButton()
                        case .fourth:
                            MatchReqTransferedMoneyAndDiscussButtonView()
                        }
                        
                    }
                }
            }
            
            if shared.judgeReqStatus() == .fourth {
                if let done = matching.data?.reqUserData.confirmedItemsAndFee.done {
                    NaviButtonView(text: "支払いと評価をする", nextView: MatchReqEvaluatelastView(), color: done ? "color1" : "color1-1")
                        .disabled(!(done))
                        .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
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
        .modalSheet(isPresented: $shared.changeRewardIsOn, backTapDismiss: false) {
            MiniModalChangeRewardView(
                text: "お礼の変更",
                button: FuncButtonView(text: "確定") {
                    // same
                    if shared.isValidInputReward() {
                        self.shared.changeRewardIsOn = false
                        self.matching.setDocument(doc: UserData.shared.data!.matchingId) {
                            self.matching.data?.request.reward = Int(shared.inputValue)!
                        }
                    }

                },
                isOn: $shared.changeRewardIsOn)
        }
        .modalSheet(isPresented: $shared.lowRewardIsOn) {
            MiniModalTwoChoicesMatchingView(
                text: "依頼時より低い金額です",
                subText: "チャットで合意を得てから変更してください",
                annotation: "必ず相手が合意するまでは変更しないでください。",
                leftButton: FuncMiniBorderButtonView(text: "戻る", processing: {
                    self.shared.lowRewardIsOn = false
                }),
                rightButton: FuncMiniButtonView(text: "変更", processing: {
                    // same
                    if shared.isValidInputRewardCaseByLow() {
                        self.shared.lowRewardIsOn = false
                        self.shared.changeRewardIsOn = false
                        self.matching.setDocument(doc: UserData.shared.data!.matchingId) {
                            self.matching.data?.request.reward = Int(shared.inputValue)!
                        }
                    }
                })
            )
        }
        .loading(isPresented: $sendMail.loading)
        .modalSheet(isPresented: $shared.consultWithTooIsOn) {
            MiniModalTwoChoicesMatchingView(
                text: "運営へ相談しますか？",
                subText: "相手と連絡や合意が取れない等\n問題があればご相談ください。\n確定後は取引を一旦中止し、運営からのメールが届くまでお待ちください。",
                leftButton: FuncMiniBorderButtonView(text: "戻る", processing: {
                    self.shared.consultWithTooIsOn = false
                }),
                rightButton: FuncMiniButtonView(text: "確定", processing: {
                    self.shared.consultWithTooIsOn = false
                    
                    let text = "MatchingId: " + matching.data!.id + " "
                    let subject = "取引上のトラブル"
                    self.sendMail.sendMessage(text: text, subject: subject)
                })
            )
        }
        .modalSheet(isPresented: $sendMail.success, backTapDismiss: false, content: {
            MiniModalOneButtonView(
                text: "連絡を受け付けました。",
                annotation: "ご連絡ありがとうございます。1日以内に\n\( UserStatus.shared.email!)\n 宛に返信致します。申し訳ありませんが一旦取引を中断し、このままお待ちください。",
                button: FuncMiniButtonView(
                    text: "閉じる",
                    processing: {
                        self.sendMail.success = false
                }),
                isOn: $sendMail.success)
        })
        .modalSheet(isPresented: $sendMail.failure, content: {
            MiniModalOneButtonView(
                text: "メッセージの送信に失敗しました。",
                annotation: "お手数をおかけして申し訳ございません。もう一度お試しの上、\ntoo.for.us@gmail.com\nに直接ご連絡ください。",
                button: FuncMiniButtonView(
                    text: "閉じる",
                    processing: {
                        sendMail.failure = false
                }),
                isOn: $sendMail.failure)
        })
        .animation(.easeInOut)
        .modalSheet(isPresented: $shared.reciptIsOn, backTapDismiss: false, blur: shared.reciptIsOn ? true : false) {
            ConfirmReciptView()
        }
    }
}

