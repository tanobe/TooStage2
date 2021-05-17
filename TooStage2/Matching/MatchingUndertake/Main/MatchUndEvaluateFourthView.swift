//
//  MatchUndEvaluateFourthView.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/16.
//

import SwiftUI

struct MatchUndEvaluateFourthView: View {
    
    @ObservedObject var matching = MatchingDataClass.shared.matching
    @StateObject var shared = MatchingDataClass.shared
    @StateObject var sendMail = WebhookSendMail()
    
    
    var body: some View {
        VStack {
            MatchingTitleView(title: "送金と評価")
            ScrollView {
                VStack(alignment: .leading) {
                    Text("以下の額が支払われました。ご確認ください。問題がなければ評価を入力し、お取引を完了してください。")
                        .subTitle()
                        .padding(.horizontal)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 40)
                    
                    MatchUndReceivedAmount()
                    
                    MatchingEvaluateView()
                        .frame(maxWidth: .infinity)
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
                        
                        ItemizationView(title: "買い物先", text: matching.data!.request.shopName)
                            .padding(.leading)
                        
                        MatchReqItemsListView()
                            .padding(.top, 20)
                        
                        MatchUndDescriptions()
                            .padding(.top, 20)
                        
                    }
                        .padding(.bottom, 20)
                    ConsultWithTooManagementButtonView()
                }
            }
            FuncButtonView(text: "評価をして取引を完了",
                           processing: {
                            self.shared.comopletedIsOn = true
                           }
            )
            .padding(.bottom, 30)
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
                annotation: "ご連絡ありがとうございます。1日以内に\n\( UserStatus.shared.email!)\n 宛に返信致します。申し訳ありませんが一旦取引を中断し、このままお待ちください",
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
        .modalSheet(isPresented: $shared.comopletedIsOn, backTapDismiss: false) {
            MiniModalTwoChoicesMatchingView(
                text: "取引を完了します",
                subText: "完了後の修正はできません",
                leftButton: FuncMiniBorderButtonView(
                    text: "戻る",
                    processing: {
                        self.shared.comopletedIsOn = false}),
                rightButton: FuncMiniButtonView(
                    text: "完了",
                    processing: {
                        
                        let now = Date().dateToString()
                        
                        // ここで最後のデータ変更
                        matching.data!.status.compUnd = true
                        matching.data!.endTime = now
                        self.shared.assignEvaluatePartner()
                        
                        // ここからはaddListenerの影響を受けないようにするために if let 使用
                        if let mdata = matching.data {
                            matching.setDocument(doc: mdata.id){}

                            // history req
                            FirestoreSet(collection: "users/\(mdata.reqUserData.uid)/matchingHistories").set(data: mdata, document: mdata.id)

                            // history und
                            FirestoreSet(collection: "users/\(mdata.undUserData.uid)/matchingHistories").set(data: mdata, document: mdata.id)

                            // evaluate req
                            let valueReq = mdata.undUserData.evaluatePartner.value
                            let bodyReq: [String: Any] = [
                                "value": valueReq,
                                "mid": mdata.id,
                                "uid": mdata.reqUserData.uid
                            ]
                            Webhook.shared.post(url: "evaluatePartner", body: bodyReq)

                            // evaluate und
                            let valueUnd = mdata.reqUserData.evaluatePartner.value
                            let bodyUnd: [String: Any] = [
                                "value": valueUnd,
                                "mid": mdata.id,
                                "uid": mdata.undUserData.uid
                            ]
                            Webhook.shared.post(url: "evaluatePartner", body: bodyUnd)
                            
                            // notif
                            let notif: [String: Any] = [
                                "fmcToken": mdata.request.fmcToken,
                                "title": "相手があなたを評価しました。",
                                "body": "これで全ての取引が完了しました。ありがとうございました！"
                            ]
                            Webhook.shared.post(url: "notification", body: notif)
                        }

                        self.shared.thanksIsOn = true
                        
                    })
            )
        }
        .modalSheet(isPresented: $shared.thanksIsOn, backTapDismiss: false) {
            ThankYouForUndMatchingView(isOn: $shared.thanksIsOn)
        }
    }
}

struct ThankYouForUndMatchingView: View {
    
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
                Text("今度はついでに依頼してみてくださいね！")
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
