//
//  PayoutView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/08.
//

import SwiftUI

struct PayoutView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var stripe = StripePayout.shared
    @StateObject var payout = StripePayout.shared.payout
    // for stripe reregister
    @StateObject var user = UserData.shared
    @StateObject var loading = LoadingTrigger.shared
    
    @State var question = false
    
    var body: some View {

        VStack {
            TitleView(present: presentationMode, title: "銀行口座に入金")
            ScrollView {
                VStack {
                    if let user = user.data {
                        if user.suid != nil {
                            if user.onboardIs {
                                CompletedOnboardingView(question: $question)
                                
                            } else {
                                UnCompleteOnboardingView()
                            }
                        } else {
                            // you have not registered yet
                        }
                    }
                }
                .frame(width: 300)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 30)
        }
        .animation(.easeInOut)
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
        .alert(isPresented: $stripe.errFee300) {
            Alert(title: Text("入金可能な残高を超えています"), message: Text("入金手数料300円を利用可能な残高から引き落とします。\(stripe.canPayoutAmount)円以内の金額を入力してください。"), dismissButton: .default(Text("はい")))
        }
        .loading(isPresented: $loading.isOn)
        .loading(isPresented: $payout.loading)
        .modalSheet(isPresented: $payout.success, backTapDismiss: false, content: {
            MiniModalOneButtonView(
                text: "入金に成功しました。",
                button: FuncMiniButtonView(
                    text: "閉じる",
                    processing: {
                        
                        // reset all of the data
                        self.stripe.inputAmount = ""
                        self.stripe.isOK = nil
                        self.stripe.getBalanceAgain()
                        self.payout.success = false
                }),
                isOn: $payout.success)
        })
        .modalSheet(isPresented: $payout.failure, content: {
            MiniModalOneButtonView(
                text: "入金に失敗しました。",
                annotation: "もう一度お試しする、または登録をみなしてみてください。お問い合わせが必要な場合は\n[プロフィール] -> [お問い合わせ]\nにてご相談ください。",
                button: FuncMiniButtonView(
                    text: "閉じる",
                    processing: {
                        payout.failure = false
                }),
                isOn: $payout.failure)
        })
        .modalSheet(isPresented: $question, content: {
            MiniModalOneButtonView(
                text: "処理中",
                annotation: "まもなく[入金可能な残高]になる金額です。\n支払いが完了してから4営業日かかります。",
                button: FuncMiniButtonView(text: "閉じる", processing: {question = false}),
                isOn: $question)
        })
    }
}


struct UnCompleteOnboardingView: View {
    // for stripe onbording reregister
    @StateObject var loading = LoadingTrigger.shared
    
    var body: some View {
        VStack {
            AnnotationRedView(text: "決済情報における銀行口座・身分証明の登録が完了していないので、ただ今銀行口座に入金することはできません。")
            FuncMiniButtonView(
                text: "登録を完了する",
                processing: {
                    self.loading.isOn = true
                    if let suid = UserData.shared.data?.suid {
                        CloudFunctionsWithStripe().createAccountLink(suid: suid)
                    } else {
                        self.loading.isOn = false
                    }
                })
                .padding(.horizontal)
        }
    }
}


struct CompletedOnboardingView: View {
    
    @StateObject var stripe = StripePayout.shared
    @StateObject var payout = StripePayout.shared.payout
    @ObservedObject var balance = StripePayout.shared.balance
    @StateObject var loading = LoadingTrigger.shared
    
    @Binding var question: Bool
    
    var body: some View {
        if let balance = balance.res {
            
            HStack {
                    VStack(spacing: 5) {
                        Text("総残高")
                            .item()
                        Text("\(balance.sum)円")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    VStack(spacing: 5) {
                        HStack(alignment: .center) {
                            Text("処理中")
                                .item()
                            Button(action: {
                                self.question = true
                            }) {
                                Image(systemName: "questionmark.circle")
                                    .font(.footnote)
                                    .foregroundColor(Color("gray1"))
                            }
                            
                        }
                        Text("\(balance.pending)円")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    VStack(spacing: 5) {
                        Text("利用可能な残高")
                            .item()
                        Text("\(balance.available)円")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                
                
                
            }
            .padding(.top, 20)
            .padding(.bottom, 50)
            .frame(height: 100)

            
            VStack(spacing: 10) {
                Text("入金可能な残高")
                    .subTitle()
                Text("\(stripe.canPayoutAmount)円")
                    .font(.title)
                    .fontWeight(.bold)
            }
        }

        PayoutTextFieldView(title: "入金金額を入力してください", example: "2000", userInput: $stripe.inputAmount, isOK: $stripe.isOK, keyboardType: .numberPad)
        
        VStack {
            
            FuncMiniButtonView(
                text: "入金する",
                processing: {
                    UIApplication.shared.closeKeyboard()
                    payout.loading = true
                    guard let suid = UserData.shared.data?.suid,
                          let amount = Int(stripe.inputAmount) else {
                        return
                    }

                    self.payout.get(url: "stripeModule-manuallyPayout", amount: amount, suid: suid)
                },
                color: (stripe.isOK ?? false) ? "color1" : "color1-1"
            )
            .disabled(!(stripe.isOK ?? false))
            .padding(.bottom)
            
            VStack(spacing: 10) {
                AnnotationRedView(text: "入金には300円の手数料がかかります。手数料は利用可能な残高から引き落とします。")
                    .frame(height: 40)
                AnnotationRedView(text: "銀行口座に実際に入金されるまでに2営業日かかります。")
                    .frame(height: 40)
                AnnotationRedView(text: "必ず送金された日から90日以内に入金してください。期限を過ぎると入金できなくなります。")
                    .frame(height: 40)
            }

        }
        .padding(.top, 30)
        
        VStack {
            FuncMiniButtonView(
                text: "登録を完了する",
                processing: {
                    self.loading.isOn = true
                    if let suid = UserData.shared.data?.suid {
                        CloudFunctionsWithStripe().createAccountLink(suid: suid)
                    } else {
                        self.loading.isOn = false
                    }
                })
                .padding(.top, 30)
                .padding(.bottom)
            Text("入金に失敗する場合はこちらから登録を完了してください。\n身分証明書による本人確認が完了しなければ、銀行口座への入金はできません。")
                .caution1()
        }
        
    }
}
