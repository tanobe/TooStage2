//
//  UndertakeView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/29.
//

import SwiftUI

struct UndertakeView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var request: Request
    
    @StateObject var itemDetail = ItemDetail.shared
    @StateObject var shopDetail = ShopDetail.shared
    
    @StateObject var payAccount = PaymentStatus.shared
    @StateObject var alert = AlertTrigger.shared
    @StateObject var loading = LoadingTrigger.shared
    
    @State var confirmIsOn = false
    
    init(request: Request) {
        self.request = request
        PaymentStatus.shared.checkPaymentStatus()
    }
    
    func setMatchingDataToFirestore() {
        
        let reqUserId = request.uid
        let undUserId = UserStatus.shared.uid! // me
        
        // Set bought to false
        let _ = request.cart.map({$0.bought = false})
        guard let suid = UserData.shared.data?.suid else {
            fatalError()
        }
        
        let matchingData = SetMatching(
            regTime: Date().dateToString(),
            request: request,
            reqUserData: RequestUserData(uid: reqUserId),
            undUserData: UndertakeUserData(uid: undUserId, suid: suid, fmcToken: UserData.shared.data!.fmcToken),
            status: MatchingStatus()
        )
        
        // make request.id - sid + uid
        let firstHalfId = request.id.prefix(42)
        let mid = firstHalfId + UserStatus.shared.uid!
        
        // update request data matched = true
        FirestoreUpdate(collection: "shops/\(request.sid)/requests").update(document: request.id, data: ["matched": true])
        
        // set to firestore
        FirestoreSet(collection: "matching").set(data: matchingData, document: String(mid))
        
        // change undertake userData matchingId = mid
        UserData.shared.updateDocument(data: ["matchingId": mid])
        
        /** use webhook to change request userData
         * requestId = ""
         * matchingId = mid */
        let requestUserId = request.uid
        let jobNameAndrequestId = request.id
        let fmcToken = request.fmcToken
        print("fmcToken: \(fmcToken)")
        let body: [String: Any] = [
            "requestUserId": requestUserId,
            "jobNameAndrequestId": jobNameAndrequestId,
            "matchingId": mid,
            "fmcToken": fmcToken
        ]
        // will be firestore-tellMatched
        Webhook.shared.post(url: "firebaseModule-triggerMatching", body: body)
        
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleView(present: presentationMode, title: "依頼詳細")
                
            ScrollView {
                VStack(alignment: .leading) {
                    Text("合計\(request.itemsTotalCaunt)点の商品の買い物依頼です。")
                        .subTitle()
                        .padding(.vertical)
                        .padding(.horizontal)
                    
                    VStack(spacing: 10) {
                        ForEach(request.cart) { item in
                            Button(action: {
                                self.itemDetail.item = item
                                self.itemDetail.isOn = true
                            }, label: {
                                // disapper the trush button
                                ItemView(item: item)
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.bottom, 20)
                    
                    VStack {
                        ItemizationTotalAmountView(title: "商品合計金額", text: "およそ\(request.itemsApxAmount)円")
                        ItemizationView(title: "買い物先　　", text: shopDetail.shop!.name)
                        ItemizationView(title: "お礼金額　　", text: "\(request.reward)円")
                        ItemizationView(title: "お届け方法　", text: request.deliveryMethod)
                        ItemizationView(title: "買い物メモ　", text: request.memo == "" ? "[買い物メモはありません]" : request.memo)
                        AnnotationRedView(text: "個人情報保護の観点から、お届け先の詳細は\n取引画面にのみ表示します。")
                            .padding(.top, 15)
                    }
                    .padding(.leading)
                    .padding(.bottom)
                }
            }
            if self.payAccount.status == .all {
                FuncButtonView(text: "ついでに買う") {
                    confirmIsOn = true
                }
            } else {
                FuncButtonView(text: "ついでに買う") {
                    payAccount.regPayModal = true
                }
            }
                
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
        .modalSheet(isPresented: $itemDetail.isOn, content: {
            ItemDetailView()
        })
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
                        text: "銀行口座を登録します",
                        annotation: "初めてご利用の方は、キャッシュバックの為に銀行口座を登録します。\nおよそ2分で登録できます。",
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
        .loading(isPresented: $loading.isOn)
        .alert(isPresented: $alert.onboardingNotFinished) {
            Alert(title: Text("登録がまだ完了していません"), message: Text("登録が完了しないとお金を振り込むことができません。\n 1. いますぐ再登録する\n 2. あとでプロフィール[銀行口座に入金]から登録を完了する\nのいずれかを実行してください。登録が完了しなければ銀行口座への入金ができません。"), dismissButton: .default(Text("はい")))
        }
        .alert(isPresented: $alert.failureOnbording) {
            Alert(title: Text("登録に失敗しました"), message: Text("再登録してください。"), dismissButton: .default(Text("はい")))
        }
        .modalSheet(isPresented: $confirmIsOn, content: {
            MiniModalTwoChoicesView(
                text: "確定以降のキャンセルには取引相手の同意が必要となります。",
                leftButton: FuncMiniBorderButtonView(text: "戻る", processing: {
                    confirmIsOn = false
                }),
                rightButton: FuncMiniButtonView(text: "確定", processing: {
                    confirmIsOn = false
                    shopDetail.dismissSheet()
                    setMatchingDataToFirestore()
                })
            )
        })
    }
}
