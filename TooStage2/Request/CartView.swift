//
//  CartView.swift
//  TooStage2
//
//  
//

import SwiftUI

struct TextEditorView: View {
    @StateObject var cart = Cart.shared
    
    var body: some View {
        ZStack(alignment: .top) {
            
            if cart.memo.isEmpty {
                VStack(alignment: .leading) {
                    Text("品切れ時の対応や、お願いしたいことがあれば書いてみましょう(買い物メモへの対応は引受人の任意です)")
                        .foregroundColor(.black)
                        .lineSpacing(10)
                        .padding(.top, 10)
                        .padding(.bottom, 5)
                        .padding(.horizontal, 5)
                    Text("最大100文字")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(.horizontal, 5)
                }
                .frame(height: 100)
            }
            
            TextEditor(text: $cart.memo)
                .lineLimit(3)
                .lineSpacing(10)
                .frame(height: 100)
                .cornerRadius(10)
                .opacity(0.8)
        }
        .background(Color(.white))
        .cornerRadius(5)
    }
}


struct CartView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @StateObject var itemDetail = ItemDetail.shared
    @StateObject var cart = Cart.shared
    @StateObject var payAccount = PaymentStatus.shared
    @StateObject var alert = AlertTrigger.shared
    @StateObject var loading = LoadingTrigger.shared
    
    init() {
        PaymentStatus.shared.checkPaymentStatus()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleView(present: presentationMode, title: "カート")
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text(cart.itemList.isEmpty ? "カートに商品はありません" :  "合計\(cart.itemsTotalCount)点の商品がカートに入っています。")
                        .subTitle()
                        .padding()
                    
                    if !cart.itemList.isEmpty {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(cart.itemList) { item in
                                Button(action: {
                                    self.itemDetail.item = item
                                    self.itemDetail.isOnUpdate = true
                                }, label: {
                                    CartItemView(item: item)
                                })
                                .buttonStyle(PlainButtonStyle())
                            }
                            ItemizationTotalAmountView(title: "商品合計金額", text: "およそ\(cart.itemsApxAmount)円")
                                .padding(.leading)
                        }
                        .padding(.bottom, 40)
                        
                        VStack(alignment: .leading) {
                            
                            Text("お届け方法を選択")
                                .subTitle()
                                .padding(.bottom, 10)
                            HStack(alignment: .center, spacing: 10) {

                                Button(action: {
                                    cart.deliveryMethod = "置き配"
                                }, label: {
                                    Text("置き配")
                                        .AorB(isColor: cart.deliveryMethod == "置き配")
                                })
                                Button(action: {
                                    cart.deliveryMethod = "手渡し"
                                }, label: {
                                    Text("手渡し")
                                        .AorB(isColor: cart.deliveryMethod == "手渡し")
                                })
                            
                            }
                            .padding(.bottom, 40)
                            
                            Text("買い物してくれる方へのお礼金額を入力")
                                .subTitle()
                                .padding(.bottom, 10)
                            
                            HStack(alignment: .center, spacing: 10) {
                                Text("お礼金額")
                                    .item()
                                TextField("100", text: $cart.reward)
                                    .padding(5)
                                    .font(Font.title.weight(.bold))
                                    .background(Color.white)
                                    .frame(width: 100)
                                    .cornerRadius(10)
                                    .offset(x: -5)
                                    .keyboardType(.numberPad)
                                    
                                Text("円")
                                    .itemRes()
                                    .offset(x: -10)
                            }
                            .padding(.bottom, 40)

                            Text("買い物してくれる方へのメモを入力")
                                .subTitle()
                                .padding(.bottom, 10)
                            
                            TextEditorView()
                                .padding(.bottom, 20)
                        }
                        .padding(.horizontal)
                        
                    }
                }
            }
            
            if !cart.itemList.isEmpty {
                if self.payAccount.status == .all {
                    NaviButtonView(text: "依頼する", nextView: RequestConfirmationView())
                } else {
                    FuncButtonView(text: "依頼する") {
                        payAccount.regPayModal = true
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
        
        .modalSheet(isPresented: $itemDetail.isOn) {
            MiniModalTwoChoicesView(
                text: "\(itemDetail.item != nil ? itemDetail.item!.name : "")をカートから削除しますか？",
                leftButton: FuncMiniBorderButtonView(text: "キャンセル", processing: {
                    itemDetail.isOn = false
                }),
                rightButton: FuncMiniButtonView(text: "削除する", processing: {
                    cart.deleteItem(item: itemDetail.item!)
                    itemDetail.isOn = false
                })
            )
        }
        .modalSheet(isPresented: $itemDetail.isOnUpdate) {
            ItemDetailUpdateView(item: itemDetail.item!)
        }
        // payment account register view
        .modalSheet(isPresented: $payAccount.regPayModal, backTapDismiss: false) {
            VStack {
                switch payAccount.status {
                case .all:
                    VStack{}
                case .onboardOnly:
                    RegistrationCreditCardView(isOn: $payAccount.regPayModal)
                case .non:
                    MiniModalOneButtonView(
                        text: "決済情報を登録します",
                        annotation: "初めてご利用の方は決済情報を登録します。\nおよそ3分で登録できます。",
                        button: FuncMiniButtonView(
                            text: "登録",
                            processing: {
                                // start loading indicator
                                // the indicator is ordered to stop at updateDocumentForPayAccount function
                                self.loading.isOn = true
                                CloudFunctionsWithStripe().createAccount()
                            }
                        ),
                        isOn: $payAccount.regPayModal
                    )
                }
            }
        }
        
        .modalSheet(isPresented: $cart.justUpdate, backTapDismiss: false) {
            TellShortMessageView(text: "カートを修正しました")
        }
        
        .loading(isPresented: $loading.isOn)
        .alert(isPresented: $alert.onboardingNotFinished) {
            Alert(title: Text("登録がまだ完了していません"), message: Text("登録が完了しないとお金を振り込むことができません。\n 1. 再登録する\n 2. あとでマイページから登録を完了する\nのいずれかを実行してください。"), dismissButton: .default(Text("はい")))
        }
        .alert(isPresented: $alert.failureOnbording) {
            Alert(title: Text("登録に失敗しました"), message: Text("再登録してください。"), dismissButton: .default(Text("はい")))
        }
        .animation(.easeInOut)
    }
}





struct ToggleInformationCartIsUpdatedView: View {
    @StateObject var cart = Cart.shared
    var body: some View {
        if cart.justIn {
            InformationCartIsUpdatedView()
        } else {
            InformationCartIsUpdatedView()
                .hidden()
        }
    }
}





struct InformationCartIsUpdatedView: View {
    var body: some View {
        HStack {
            Spacer()
            ZStack(alignment: .topTrailing) {
                Image(systemName: "triangle.fill")
                    .font(.caption)
                    .foregroundColor(Color("FBED96"))
                    .offset(x: -15, y: -10)
                Text("カートに商品が追加されました")
                    .font(.caption)
                    .foregroundColor(Color("color1"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color("FBED96"))
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.trailing, 10)

    }
}
