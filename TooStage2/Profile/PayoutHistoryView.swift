//
//  PayoutHistoryView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/16.
//

import SwiftUI

struct SetPayoutHistory: Codable {
    var time: String
    var description: String
    var amount: Int
}

struct PayoutHistory: Codable, Identifiable, Equatable {
    // suid + date
    var id: String
    var time: String
    var description: String
    var amount: Int
}

struct PayoutHistoryColumnView: View {
    var data :PayoutHistory
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(data.time)
                    .font(.subheadline)
                Text(data.description)
                    .font(.callout)
                    .fontWeight(.bold)
            }
            Spacer()
            VStack {
                Text("\(data.amount)円")
            }
        }
        .padding()
    }
}

struct PayoutHistoryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var histories = FireStoreGetList<PayoutHistory>(collection: "users/\(UserStatus.shared.uid!)/payoutHistories")

    
    var body: some View {
        VStack {
            TitleView(present: presentationMode, title: "入金履歴")
            if histories.list.isEmpty {
                VStack {
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
                }
            } else {
                List {
                    ForEach(histories.list.sorted(by: {$0.time > $1.time})) { his in
                        PayoutHistoryColumnView(data: his)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
        .onAppear {
            histories.getList()
        }
    }
}
