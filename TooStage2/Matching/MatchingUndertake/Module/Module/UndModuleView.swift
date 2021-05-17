//
//  UndModuleView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/14.
//

import SwiftUI

//MARK: - MatchUndertakeDescriptions

struct MatchUndDescriptions: View {
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
                    // 未確定
                } else {
                    ItemizationTotalAmountView(title: "商品合計金額", text: "およそ\(matching.request.itemsApxAmount)円")
                    //Undertakeユーザーであるため手数料の情報は見せる必要なし。
//                    ItemizationSomeCautionView(title: "手数料　　　", text: "およそ\(matching.request.apxFee)円", caution: "商品の合計金額に対する10%の手数料")
                }
                ItemizationView(title: "お礼金額　　", text: "\(matching.request.reward)円")
                ItemizationView(title: "買い物メモ　", text: matching.request.memo)
                ItemizationView(title: "お届け方法　", text: matching.request.deliveryMethod)
            }
        }
        .padding(.leading)
    }
}

//MARK: - MatchUndApxReceivedAmount
struct MatchUndReceivedAmount: View {
    @StateObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    
    var body: some View {
        VStack(alignment: .leading) {
            if let matching = matching.data {
                Text("受取合計金額")
                    .subTitle()
                    .padding(.leading)
                    .padding(.bottom, 15)
                Text("\(matching.paidToUndExaAmount)円")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .padding(.leading)
            }
        }
    }
}

//MARK: - MatchUnderNowStatusView
struct MatchUnderNowStatusView: View {
    var subTitle: String = "現在のステータス"
    var title: String
    var body: some View {
        VStack(spacing: 15) {
            Text(subTitle)
                .subTitle()
                .multilineTextAlignment(.center)
             Text(title)
                .fontWeight(.bold)
                .font(.title)
                .foregroundColor(Color("color1"))
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
    }
}


//MARK: -　MatchUnderNextActionView
struct MatchUnderNextActionView: View {
    var title: String = "次の画面ですること"
    var subTitle: String
    var body: some View {
        VStack(spacing: 15) {
            Text(title)
                .fontWeight(.bold)
                .font(.caption)
                .foregroundColor(Color("color3"))
             Text(subTitle)
                .subTitle2()
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
    }
}

//MARK: - MatchUnderMiniModalOneButtonView
struct MatchUnderMiniModalOneButtonView<BV: ButtonProtocol>: View {
    var text: String
    var subText: String? = nil
    var button: BV
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Text(text)
                    .fontWeight(.bold)
                    .font(.title3)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .center) {
                if subText != nil {
                    Text(subText!)
                        .fontWeight(.medium)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
            }
            .frame(maxWidth: .infinity)
            
            button
                .padding(.top, 20)
                .padding(.horizontal)
            
        }
        .padding(.horizontal, 30)
        .padding(.top, 20)
        .padding(.bottom, 30)
        .background(Color(.white))
        .frame(width: 300)
        .cornerRadius(10)
    }
}

//MARK: - matchUndSubText
extension Text {
    func matchUndSubText() -> some View {
        self
            .fontWeight(.medium)
            .font(.subheadline)
            .foregroundColor(Color("color2"))
    }
}


//MARK: - NaviMiniDefWithActiveButtonView
struct NaviMiniDefWithActiveButtonView<V: View>: ButtonProtocol {

    var text: String
    var processing = non
    var nextView: V
    var color: String = "color1"
    
    var body: some View {
        NavigationLink(destination: nextView) {
            Text(text)
                .buttonMiniDef(color: color)
        }.simultaneousGesture(TapGesture().onEnded{
            processing()
        })
    }
}
