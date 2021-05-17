//
//  ConfirmationRequestView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/25.
//

import SwiftUI

struct RequestConfirmationView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var itemDetail = ItemDetail.shared
    @StateObject var cart = Cart.shared
    @StateObject var payAccount = PaymentStatus.shared
    @StateObject var shopDetail = ShopDetail.shared
    @StateObject var userData = UserData.shared
    @StateObject var alert = AlertTrigger.shared
    
    
    @State var confirmIsOn = false
    @State var thanksIsOn = false
    
    func confirmation() {
        if checkRewawrd() {
            self.confirmIsOn = true
        }
    }
    func checkRewawrd() -> Bool {
        guard let reward = Int(cart.reward) else {
            return false
        }
        if reward < 100 {
            alert.rewardAlert = true
            return false
        }
        return true
    }


    func setRequestDataToFirestore() {
        guard let user = userData.data,
              let shop = shopDetail.shop else {
            return
        }
        let date = Date()
        let rid = user.id + date.dateToSimpleStringFormat() + shopDetail.shop!.id
        
        // set to /shop/[shop id]/requests
        let data = SetRequest(sid: shop.id,
                              shopName: shop.name,
                              regTime: date.dateToString(),
                              uid: user.id,
                              fmcToken: user.fmcToken,
                              sex: user.sex,
                              cart: cart.itemList,
                              deliveryAddress: user.addressWithRoomNum,
                              deliveryMethod: cart.deliveryMethod,
                              reward: Int(cart.reward)!,
                              memo: cart.memo)
        FirestoreSet(collection: "shops/\(shop.id)/requests").set(data: data, document: rid)
        
        // update userData after success this
        userData.updateDocument(data: ["requestId": rid])
        
        // delete Request after one hour
        let body: [String: Any] = [
            "rid": rid,
            "sid": shop.id,
            "uid": user.id
        ]
        Webhook.shared.post(url: "firebaseModule-triggerRequest", body: body)
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleView(present: presentationMode, title: "確認")
            ScrollView {
                VStack(alignment: .leading) {
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("予定支払合計金額")
                                .subTitle()
                            Text("\(cart.totalApxAmount)円")
                                .fontWeight(.bold)
                                .font(.largeTitle)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                    
                    Text("合計\(cart.itemsTotalCount)点の商品の買い物を依頼します。")
                        .subTitle()
                        .padding()
                    
                    VStack(spacing: 10) {
                        ForEach(cart.itemList) { item in
                            Button(action: {
                                self.itemDetail.item = item
                                self.itemDetail.isOnUpdate = true
                            }, label: {
                                CartItemView(item: item)
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        
                        ItemizationTotalAmountView(title: "商品合計金額", text: "およそ\(cart.itemsApxAmount)円")
                        ItemizationSomeCautionView(title: "手数料　　　", text: "およそ\(cart.apxFee)円", caution: "商品の合計金額に対する10%の手数料")
                        ItemizationView(title: "買い物先　　", text: shopDetail.shop!.name)
                        ItemizationView(title: "お届け先　　", text: userData.data!.addressWithRoomNum)
                        ItemizationView(title: "お届け方法　", text: cart.deliveryMethod)
                        ItemizationCreditCardView(title: "決済方法　　", text: "**** \(String(describing: userData.data!.card!.last4))")
                        ItemizationWithButtonView(title: "お礼金額　　", text: cart.reward + "円", processing: {presentationMode.wrappedValue.dismiss()})
                        ItemizationWithButtonView(title: "買い物メモ　", text: cart.memo, processing: {presentationMode.wrappedValue.dismiss()})
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
                
            }
            FuncButtonView(text: "依頼確定", processing: {
                confirmation()
            })
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
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
        .modalSheet(isPresented: $cart.justUpdate, backTapDismiss: false) {
            TellShortMessageView(text: "カートを修正しました")
        }
        .modalSheet(isPresented: $payAccount.regPayModal, backTapDismiss: false) {
            UpdateCreditCardView(isOn: $payAccount.regPayModal)
        }
        .alert(isPresented: $alert.rewardAlert, content: {
            Alert(title: Text("お礼の金額が少ないです"), message: Text("お礼の金額は100円以上に設定してください"), dismissButton: .default(Text("はい")))
        })
        .modalSheet(isPresented: $confirmIsOn) {
            MiniModalTwoChoicesView(
                text: "依頼を確定しますか？\n決済は配達完了後に行われます。",
                leftButton: FuncMiniBorderButtonView(text: "戻る", processing: {
                    confirmIsOn = false
                }),
                rightButton: FuncMiniButtonView(text: "確定", processing: {
                    
                    ShopDetail.shared.dismissSheet()
                    
                    confirmIsOn = false
                    thanksIsOn = true
                    /**
                     * set data to firestore in here
                     */
                    setRequestDataToFirestore()
                })
            )
        }
        .modalSheet(isPresented: $thanksIsOn, backTapDismiss: false) {
            ThankYouForRequestView(isOn: $thanksIsOn)
        }
        .animation(.easeInOut)
    }
}








struct ThankYouForRequestView: View {
    @Binding var isOn: Bool
    
    var body: some View {
        VStack {
            Image("Smiling")
                .resizable()
                .frame(width: 180, height: 180)
                .padding(.bottom)
            
            VStack(alignment: .center, spacing: 5) {
                Text("ご依頼ありがとうございます！")
                    .head()
                Text("ついでに買い物に行けるユーザーを探しています。\nマッチングが完了するまでお待ちください。")
                    .font(.footnote)
            }
            .padding(.bottom)
            
            AnnotationRedView(text: "注文から1時間経ってもマッチングが成立しない場合には、自動的にキャンセルされます。")
            AnnotationRedView(text: "マッチング成立後のキャンセルには双方の同意が必要です。")
                .padding(.bottom)
            
            FuncMiniButtonView(text: "ホーム画面に戻る", processing: {
                
                /** back to home as well as to UndertakeView */
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.toContentView()
                /** send notification to some users*/
                
                //To allow users to modify their request data, you may need to leave the cart.
                Cart.shared.removeAll()
                
                isOn = false
                
            })
            .padding(.horizontal, 30)
        }
        .padding(30)
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(10)
    
    }
}
