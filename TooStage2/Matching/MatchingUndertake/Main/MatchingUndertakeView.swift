//
//  MatchingUndertakeView2.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/16.
//

import SwiftUI

class ScrollPosition: ObservableObject {
    @Published var aaa = false
}

struct MatchingUndertakeView: View {

    @StateObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    
    init() {
        self.matching.getDocument(doc: UserData.shared.data!.matchingId)
    }
    
    var body: some View {

        VStack {
            VStack(alignment: .leading) {
                switch shared.judgeUndStatus() {
                case .first:
                    MatchUndBeforeArrivingStoreFirstView()
                case .second:
                    MatchUndShoppingSecondView()
                case .thired:
                    MatchUndWaitingForTransferdMoneyThiredView()
                case .fourth:
                    MatchUndEvaluateFourthView()
                }
            }
        }
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
        .modalSheet(isPresented: $shared.underArrivingStoreIsOn) {
            MiniModalTwoChoicesMatchingView (
                text: "お店に到着したと通知を送ってよろしいですか？",
                subText: "次の画面では買い物リストの\nチェックに移ります。",
                leftButton: FuncMiniBorderButtonView(text: "戻る", processing: {
                    self.shared.underArrivingStoreIsOn = false
                }),
                rightButton: FuncMiniButtonView(text: "進む", processing: {
                    self.shared.underArrivingStoreIsOn = false
                    self.matching.setDocument(doc: UserData.shared.data!.matchingId) {
                        self.matching.data?.undUserData.arrivedShop = shared.setTimeAndBool()
                    }
                })
            )
        }
        .modalSheet(isPresented: $shared.undDeliveringIsOn) {
            MiniModalTwoChoicesMatchingView (
                text: "お届け中に切り替えます",
                subText: "切り替えるには次の画面でレシートの送信が必要です",
                leftButton: FuncMiniBorderButtonView(text: "戻る", processing: {
                    self.shared.undDeliveringIsOn = false
                }),
                rightButton: NaviMiniDefButtonView(
                    text: "進む",
                    nextView: MatchUndSendReceiptView())
            )
        }
        .animation(.easeInOut)
    
    }
}
