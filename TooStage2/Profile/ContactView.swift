//
//  ContactView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/10.
//

import SwiftUI

struct TextEditorContactView: View {
    @Binding var text: String
    var body: some View {
        ZStack(alignment: .top) {
            if text.isEmpty {
                VStack {
                    HStack {
                        Text("お問い合わせ内容を記入")
                            .foregroundColor(.black)
                            .lineSpacing(10)
                            .padding(.top, 10)
                            .padding(.bottom, 5)
                            .padding(.horizontal, 5)
                        Spacer()
                    }
                    
                    Spacer()
                }
                .frame(width: 300, height: 300)
            }
            
            TextEditor(text: $text)
                .frame(width: 300, height: 300)
                .lineSpacing(10)
                .cornerRadius(10)
                .opacity(0.8)
            
        }
        .background(Color(.white))
        .cornerRadius(5)
    }
    
}

struct ContactView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @StateObject var sendMail = WebhookSendMail()
    
    @State var text = ""
    @State var selection = "ユーザー間のトラブル"
    let strengths = ["ユーザー間のトラブル", "その他トラブル", "個人情報の変更", "ご意見・ご感想", "入金について", "退会手続き", "その他"]
    
    var body: some View {
        VStack {
            TitleView(present: presentationMode, title: "お問い合わせ")
            
            Spacer()
            
            VStack(spacing: 20) {
                Text("選択してください")
                Picker("タイトル", selection: $selection) {
                    ForEach(strengths, id: \.self) {
                        Text($0)
                    }
                }
                .frame(height: 80)
                .clipped()
                
                TextEditorContactView(text: $text)
                
                
                FuncButtonView(
                    text: "送信",
                    processing: {
                        sendMail.sendMessage(text: text, subject: selection)
                    },
                    color: (self.text != "") ? "color1" : "color1-1"
                )
                .disabled(self.text == "")
            }
            .frame(width: 300)
            
            Spacer()
            Spacer()
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
        .loading(isPresented: $sendMail.loading)
        .modalSheet(isPresented: $sendMail.success, backTapDismiss: false, content: {
            MiniModalOneButtonView(
                text: "メッセージを受け付けました。",
                annotation: "ご連絡ありがとうございます。1日以内に\n\( UserStatus.shared.email!)\n 宛に返信致します。",
                button: FuncMiniButtonView(
                    text: "閉じる",
                    processing: {
                        self.text = ""
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
