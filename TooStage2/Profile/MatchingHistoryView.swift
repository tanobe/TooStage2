//
//  HistoryView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/03.
//

import SwiftUI

struct ReqMatchingHistoryDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var recipts = FireStorageGetList()
    var data: Matching
    
    init(data: Matching) {
        self.data = data
        let imagesUrl = "/matching/" + data.id + "/recipt"
        self.recipts.getList(url: imagesUrl)
    }
    
    var body: some View {
        VStack{
            TitleView(present: presentationMode, title: "取引詳細")
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        ItemizationView(title: "取引開始時刻", text: data.regTime)
                        ItemizationView(title: "取引終了時刻", text: data.endTime)
                        ItemizationView(title: "買い物先　　", text: data.request.shopName)
                        ItemizationView(title: "商品合計金額", text: "\(data.undUserData.sentRecipt.exactAmount)")
                        ItemizationView(title: "手数料　　　", text: "\(data.exaFee)円")
                        ItemizationView(title: "お礼金額　　", text: "\(data.request.reward)円")
                        ItemizationView(title: "買い物メモ　", text: data.request.memo)
                        ItemizationView(title: "お届け方法　", text: data.request.deliveryMethod)
                        
                        ItemizationView(title: "評価　　　　", text: "\(data.undUserData.evaluatePartner.value)")
                    }
                    
                    
                    Text("レシート")
                        .item()
                        .padding(.top, 20)
                    ScrollView(.horizontal) {
                        HStack(alignment: .top, spacing: 5) {
                            ForEach(recipts.list) { img in
                                img.image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(5)
                            }
                            .frame(height: 200)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("支払金額")
                            .subTitle()
                        Text("\(data.totalExaAmount)円")
                            .fontWeight(.bold)
                            .font(.largeTitle)
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 50)
            }
            .padding(.bottom, 50)
            
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
    }
}

struct UndMatchingHistoryDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var recipts = FireStorageGetList()
    var data: Matching
    
    init(data: Matching) {
        self.data = data
        let imagesUrl = "/matching/" + data.id + "/recipt"
        self.recipts.getList(url: imagesUrl)
    }
    
    var body: some View {
        VStack{
            TitleView(present: presentationMode, title: "取引詳細")
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        ItemizationView(title: "取引開始時刻", text: data.regTime)
                        ItemizationView(title: "取引終了時刻", text: data.endTime)
                        ItemizationView(title: "買い物先　　", text: data.request.shopName)
                        ItemizationView(title: "商品合計金額", text: "\(data.undUserData.sentRecipt.exactAmount)")
                        ItemizationView(title: "お礼金額　　", text: "\(data.request.reward)円")
                        ItemizationView(title: "買い物メモ　", text: data.request.memo)
                        ItemizationView(title: "お届け方法　", text: data.request.deliveryMethod)
                        
                        ItemizationView(title: "評価　　　　", text: "\(data.reqUserData.evaluatePartner.value)")
                    }
                    
                    
                    Text("レシート")
                        .item()
                        .padding(.top, 20)
                    ScrollView(.horizontal) {
                        HStack(alignment: .top, spacing: 5) {
                            ForEach(recipts.list) { img in
                                img.image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(5)
                            }
                            .frame(height: 200)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("受取金額")
                            .subTitle()
                        Text("\(data.paidToUndExaAmount)円")
                            .fontWeight(.bold)
                            .font(.largeTitle)
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 50)
            }
            .padding(.bottom, 50)
            
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
    }
}

struct MatchingHistoryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var user = UserStatus.shared
    @ObservedObject var histories = FireStoreGetList<Matching>(collection: "users/\(UserStatus.shared.uid ?? "err")/matchingHistories")
    
    func side(data: Matching) -> MatchingSide {

        if data.status.cancelReq && data.status.cancelUnd {
            return .cancel
        }
        
        if data.reqUserData.uid == UserStatus.shared.uid! {
            return .request
        } else {
            return .undertake
        }
    }
    
    var body: some View {
        VStack {
            TitleView(present: presentationMode, title: "取引履歴")
            if histories.list.isEmpty {
                VStack(spacing: 15) {
                    Spacer()
                    Image("Thinking")
                        .resizable()
                        .frame(width: 120, height: 120)
                    Text("履歴はありません")
                        .title3Color()
                    Spacer()
                    Spacer()
                }
            } else {
                List {
                    ForEach(histories.list.sorted(by: {$0.endTime > $1.endTime})) { his in
                        switch self.side(data: his) {
                        case .cancel:
                            CanMatchingHistoryView(data: his)
                        case .request:
                            NavigationLink(destination: ReqMatchingHistoryDetailView(data: his)) {
                                ReqMatchingHistoryView(data: his)
                            }
                        case .undertake:
                            NavigationLink(destination: UndMatchingHistoryDetailView(data: his)) {
                                UndMatchingHistoryView(data: his)
                            }
                        }
                    }
                }
            }
            
        }
        .onAppear {
            histories.getList()
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
    }
}

enum MatchingSide {
    case request
    case undertake
    case cancel
}


struct ReqMatchingHistoryView: View {
    var data: Matching
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(data.endTime)
                    .font(.subheadline)
                    
                HStack(spacing: 15) {
                    HStack(spacing: 5) {
                        // exactTotalAmount
                        Text("支払金額")
                            .fontWeight(.bold)
                            .font(.footnote)
                            .foregroundColor(Color("gray1"))
                        Text("\(data.totalExaAmount)円")
                            .itemRes()
                            
                    }
                    HStack(spacing: 5) {
                        Text("商品数")
                            .fontWeight(.bold)
                            .font(.footnote)
                            .foregroundColor(Color("gray1"))
                        Text("\(data.request.itemsTotalCaunt)点")
                            .itemRes()
                    }
                    HStack(spacing: 5) {
                        Text("評価")
                            .fontWeight(.bold)
                            .font(.footnote)
                            .foregroundColor(Color("gray1"))
                        Text("\(data.undUserData.evaluatePartner.value)")
                            .itemRes()
                    }
                }
            }
            Spacer()
            VStack {
                Text("依頼")
                    .reqSide()
            }
        }
        .padding()
    }
}

struct UndMatchingHistoryView: View {
    var data: Matching
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(data.endTime)
                    .font(.subheadline)
                    
                HStack(spacing: 15) {
                    HStack(spacing: 5) {
                        // itemTotalAmount + fee
                        Text("受取金額")
                            .fontWeight(.bold)
                            .font(.footnote)
                            .foregroundColor(Color("gray1"))
                        Text("\(data.paidToUndExaAmount)円")
                            .itemRes()
                            
                    }
                    HStack(spacing: 5) {
                        Text("商品数")
                            .fontWeight(.bold)
                            .font(.footnote)
                            .foregroundColor(Color("gray1"))
                        Text("\(data.request.itemsTotalCaunt)点")
                            .itemRes()
                    }
                    HStack(spacing: 5) {
                        Text("評価")
                            .fontWeight(.bold)
                            .font(.footnote)
                            .foregroundColor(Color("gray1"))
                        Text("\(data.reqUserData.evaluatePartner.value)")
                            .itemRes()
                    }
                }
            }
            Spacer()
            VStack {
                Text("請負")
                    .undSide()
            }
        }
        .padding()
    }
}

struct CanMatchingHistoryView: View {
    var data: Matching
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(data.regTime)
                    .font(.subheadline)
            }
            Spacer()
            VStack {
                Text("中止")
                    .canSide()
            }
            .padding(.trailing, 20)
        }
        .padding()
    }
}
