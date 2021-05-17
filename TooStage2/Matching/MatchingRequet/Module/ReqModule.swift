//
//  Items.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/03/24.
//

import SwiftUI


//MARK: - CheckItemView

struct MatchReqItemsListView: View {
    @ObservedObject var matching = MatchingDataClass.shared.matching
    var body: some View {
        VStack {
            if let matching = matching.data {
                ForEach(matching.request.cart) { item in
                    MatchReqCheckItemView(item: item)
                }
            }
        }
    }
}

struct MatchReqCheckItemView: View {

    @ObservedObject var item: Item

    var body: some View {
        HStack(spacing: 10) {
            HStack {
                item.image
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 4.5, height: UIScreen.main.bounds.width / 4.5)
                    .cornerRadius(10)
                
            }
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(item.name)
                        .fontWeight(.semibold)
                        .font(.title3)
                    Text("\(item.value)円")
                        .fontWeight(.bold)
                        .font(.footnote)
                    Spacer()
                    HStack {
                        Text("個数")
                            .fontWeight(.bold)
                            .font(.footnote)
                            .foregroundColor(Color("gray1"))
                        Text(item.quantity!)
                            .fontWeight(.bold)
                            .font(.body)
                    }
                }
                
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    if item.bought ?? false {
                        Text("購入済み")
                            .bought()
                    } else {
                        Text("未購入")
                            .unbought()
                    }

                    Spacer()
                    HStack {
                        Text("合計")
                            .item()
                        Text("\(item.value * Int(item.quantity!)!)円")
                            .itemRes()
                    }
                }
                
            }
            .frame(height: UIScreen.main.bounds.width / 4.5)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(5)
        .shadow1(radius: 5)
        .padding(.horizontal)
    }
}



//MARK: - MatchReqTransferedMoneyAndDiscussButton
struct MatchReqTransferedMoneyAndDiscussButtonView: View {
    @StateObject var matching = MatchingDataClass.shared.matching
    @StateObject var shared = MatchingDataClass.shared

    var body: some View {
        VStack(alignment: .leading) {
            MatchReqDescriptionsForFourthView()
            
            
            VStack(alignment: .leading, spacing: 10) {
            
                if let matching = matching.data {
                    // exact Amount が確定した場合
                    if matching.reqUserData.confirmedItemsAndFee.done {
                        Text("支払合計金額")
                            .subTitle()
                        Text("\(matching.totalExaAmount)円")
                            .fontWeight(.bold)
                            .font(.largeTitle)
                    } else {
                        Text("予定支払合計金額")
                            .subTitle()
                        Text("\(matching.request.totalApxAmount)円")
                            .fontWeight(.bold)
                            .font(.largeTitle)
                    }
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 30)
            .padding(.leading)
            
            ConsultWithTooManagementButtonView()
                .padding(.bottom, 5)
        }
    }
}

// MARK: - MatchReqDescriptionsForUpToThird
struct MatchReqDescriptionsForUpToThirdView: View {
    @StateObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    
    var body: some View {
        VStack(alignment: .leading) {
            if let matching = matching.data {
                ItemizationTotalAmountView(title: "商品合計金額", text: "およそ\(matching.request.itemsApxAmount)円")
                ItemizationSomeCautionView(title: "手数料　　　", text: "およそ\(matching.request.apxFee)円", caution: "商品合計金額に対する10%の手数料")
                ItemizationView(title: "お礼金額　　", text: "\(matching.request.reward)円")
                Button(action: {
                    self.shared.changeRewardIsOn = true
                }, label: {
                    Text("お礼金額を変更")
                        .miniAlernation()
                })
                ItemizationView(title: "買い物メモ　", text: matching.request.memo)
                ItemizationView(title: "お届け方法　", text: matching.request.deliveryMethod)
            } else {
                let _ = print("\no data no data no data")
            }
        }
        .padding()
    }
}


//MARK: - MatchingViewDescriptionsForFourth
struct MatchReqDescriptionsForFourthView: View {
    @StateObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    
    func exactFee(exactAmount: Int) -> Int {
        return Int(floor(Double(exactAmount) * 0.01 * 10))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let matching = matching.data {
                // exact Amount が確定した場合
                if matching.reqUserData.confirmedItemsAndFee.done {
                    ItemizationView(title: "商品合計金額", text: "\(matching.undUserData.sentRecipt.exactAmount)円")
                        .padding(.top, -10)
                    ItemizationSomeCautionView(title: "手数料　　　", text: "\(self.exactFee(exactAmount: matching.undUserData.sentRecipt.exactAmount))円", caution: "商品の合計金額に対する10%の手数料")
                // 未確定
                } else {
                    ItemizationTotalAmountView(title: "商品合計金額", text: "およそ\(matching.request.itemsApxAmount)円")
                        .padding(.top, -10)
                    ItemizationSomeCautionView(title: "手数料　　　", text: "およそ\(matching.request.apxFee)円", caution: "商品の合計金額に対する10%の手数料")
                }
                
                
                ItemizationView(title: "お礼金額　　", text: "\(matching.request.reward)円")
                
                Button(action: {
                    self.shared.changeRewardIsOn = true
                }, label: {
                    Text("お礼金額を変更")
                        .miniAlernation()
                })
                
                ItemizationView(title: "買い物メモ　", text: matching.request.memo)
                ItemizationView(title: "お届け方法　", text: matching.request.deliveryMethod)
            } else {
                let _ = print("\no data no data no data")
            }
        }
        .padding()
    }
}

//MARK: - MatchingViewRequest Descriptions
struct MatchReqDescriptionsView: View {
    @StateObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    
    var body: some View {
        VStack(alignment: .leading) {
            if let matching = matching.data {
                // exact Amount が確定した場合
                if matching.reqUserData.confirmedItemsAndFee.done {
                    ItemizationView(title: "商品合計金額", text: "\(matching.undUserData.sentRecipt.exactAmount)円")
                    ItemizationSomeCautionView(title: "手数料　　　", text: "\(matching.exaFee)円", caution: "商品の合計金額に対する10%の手数料")
                // 未確定
                } else {
                    ItemizationTotalAmountView(title: "商品合計金額", text: "およそ\(matching.request.itemsApxAmount)円")
                    ItemizationSomeCautionView(title: "手数料　　　", text: "およそ\(matching.request.apxFee)円", caution: "商品の合計金額に対する10%の手数料")
                }
                
                ItemizationView(title: "お礼金額　　", text: "\(matching.request.reward)円")
                
                ItemizationView(title: "買い物メモ　", text: matching.request.memo)
                ItemizationView(title: "お届け方法　", text: matching.request.deliveryMethod)
                
                ItemizationCreditCardView(title: "決済方法　　", text: "**** \(String(describing: UserData.shared.data!.card!.last4))")
            }
        }
        .padding()
    }
}

//MARK: -MiniModalChangeRewardView
struct MiniModalChangeRewardView<BV: ButtonProtocol> : View {
    
    var text: String
    var annotaionText1 = "依頼時よりも低い価格で支払いを成立させるには、相手の方の同意が必要です。"
    var button: BV
    @Binding var isOn: Bool
    
    @StateObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    
    var body: some View {
        VStack(alignment: .center) {
            MiniDismissView(isOn: $isOn)
            Text(text)
                .fontWeight(.bold)
                .font(.title3)
            VStack(spacing: 5) {
                AnnotationRedView(text: annotaionText1)
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            HStack(spacing: 10) {
                Text("お礼金額")
                    .fontWeight(.bold)
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                TextField("\(self.matching.data!.request.reward)", text: $shared.inputValue)
                    .keyboardType(.numberPad)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .frame(width: 60)
                    .background(Color("gray2"))
                    .cornerRadius(10)
                Text("円")
                Spacer()
            }
            button
        }
        .padding(.horizontal, 30)
        .padding(.top, 20)
        .padding(.bottom, 30)
        .frame(width: 300)
        .background(Color(.white))
        .cornerRadius(10)
    }
}

