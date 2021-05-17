//
//  MatchUndWaitingForTransferdMoneyThiredView.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/16.
//

import SwiftUI

struct MatchUndWaitingForTransferdMoneyThiredView: View {
    @StateObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    @StateObject var sendMail = WebhookSendMail()
    
    var body: some View {
        VStack {
            MatchingTitleView(title: "待機中")
            
            Spacer()
            
            Image("Thinking")
            
            
            VStack(spacing: 10) {
                Text("送金を待っています。")
                    .fontWeight(.bold)
                    .font(.title3)
                    .foregroundColor(Color("color1"))
                
                Text("お届けありがとうございます。\n依頼者が商品と支払額の一致\nを確認した後に決済します。\nしばらくお待ちください。")
                    .fontWeight(.medium)
                    .font(.subheadline)
                    .foregroundColor(Color("color1"))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            VStack(spacing: 20) {

                NaviChatButtonView()
                ConsultWithTooManagementButtonView()
                
            }
            .padding(.bottom, 35)
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
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
    }
}
