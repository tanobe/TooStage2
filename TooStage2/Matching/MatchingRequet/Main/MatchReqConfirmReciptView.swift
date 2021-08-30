//
//  ConfirmReciptView.swift
//  TooStage2
//
// 
//

import SwiftUI

struct ConfirmReciptView: View {

    @ObservedObject var matching = MatchingDataClass.shared.matching
    @StateObject var shared = MatchingDataClass.shared
    
    @ObservedObject var images = FireStorageGetList()
    
    var body: some View {
        VStack(spacing: 20) {
            MiniDismissView(isOn: $shared.reciptIsOn, color: .white)
            
            if let recipt = matching.data?.undUserData.sentRecipt {
                VStack {
                    Text("\(images.list.count)枚 下へスクロール")
                        .font(.callout)
                        .foregroundColor(.white)
                        .fontWeight(.light)
                    ScrollView {
                        ForEach(self.images.list) { i in
                            i.image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                        }

                    }
                    .cornerRadius(10)
                }
                .frame(height: UIScreen.main.bounds.width)
                
                HStack {
                    VStack {
                        Text("申請された商品合計金額")
                            .subTitle()
                        Text("（支払金額に反映されます）")
                            .subTitle()
                    }
                    
                    Spacer()
                    Text("\(recipt.exactAmount)円")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                
                VStack(spacing: 10) {
                    FuncMiniButtonView(text: "商品・金額が正しいことを確認済みにする", processing: {
                        matching.setDocument(doc: UserData.shared.data!.matchingId) {
                            self.matching.data?.reqUserData.confirmedItemsAndFee = shared.setTimeAndBool()
                        }
                        shared.reciptIsOn = false
                    })
                    FuncMiniBorderButtonView(text: "戻る", processing: {
                        shared.reciptIsOn = false
                    })
                }
            }
        }
        .padding()
        .offset(y: -10)
        .onAppear {
            let imagesUrl = "/matching/" + UserData.shared.data!.matchingId + "/recipt/"
            self.images.getList(url: imagesUrl)
        }
    }
}
