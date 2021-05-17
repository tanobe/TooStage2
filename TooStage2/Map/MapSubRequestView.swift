//
//  MapSubRequestView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/26.
//

import SwiftUI

struct MapSubRequestView: View {
    
    @ObservedObject var requests = ShopDetail.shared.shop!.requests

    var body: some View {
        
        if requests.reqList.count != 0 {
            ScrollView {
                /** t might need to display " this is request list " */
                /** THIS IS A BUG
                 * Max height of ForEach View depends on height of parent View MapSubView in ,
                 * mutable sheet thats height is UIScreen.main.bounds.height * 3 / 4 now.
                 * When the requests is more than 4 in device of SE 2 generation,
                 * elements of ForEach view will be out of sight.
                 */
                VStack {
                    ForEach(requests.reqList) { request in
                        NavigationLink(destination: UndertakeView(request: request)) {
                            RequestDetail(request: request)
                        }.simultaneousGesture(TapGesture().onEnded{
                            // load image here
                            for item in request.cart {
                                item.loadImage()
                            }
                        })
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                
            }
        } else {
            VStack(spacing: 15) {
                Spacer()
                Image("Thinking")
                    .resizable()
                    .frame(width: 120, height: 120)
                Text("現在買い物の依頼は\nありません")
                    .title3Color()
                    .fixedSize()
                Text("買い物に行く予定の方は下のボタンから\nアナウンスをしてみましょう")
                    .comment()
                    .fixedSize()
                Spacer()
            }
        }
    
    }
}

struct RequestDetail: View {
    @ObservedObject var request: Request
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {

                if request.cart.count != 0 {
                    Text("\(request.cart[0].name)を含む\(request.itemsTotalCaunt)品の注文")
                        .fontWeight(.semibold)
                        .font(.headline)
                        .foregroundColor(Color("color2"))
                } else {
                    Text("NaNを含むNaN品の注文")
                        .fontWeight(.semibold)
                        .font(.headline)
                        .foregroundColor(Color("color2"))
                }
                
                HStack {
                    Text("\(request.deliveryMethod)　")
                        .fontWeight(.medium)
                        .font(.caption)
                    Text("想定金額 \(request.itemsApxAmount)円　")
                        .fontWeight(.medium)
                        .font(.caption)
                    Text("お礼 \(request.reward)円")
                        .fontWeight(.medium)
                        .font(.caption)
                    Spacer()
                }
                .foregroundColor(Color("gray3"))
                
                
                Text(request.regTime.convertToHHmm())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 5)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .background(Color.white)
        .cornerRadius(10)
        .shadow1(radius: 5)
    }
}
