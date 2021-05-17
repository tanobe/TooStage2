//
//  ItemizationTestView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/26.
//

import SwiftUI

struct ItemizationView: View {
    var title: String
    var text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(title)
                .item()
            Text(text)
                .itemRes()
                .offset(y: -2)
            Spacer()
        }
        .padding(.top, 20)
    }
}

struct ItemizationTotalAmountView: View {
    var title: String
    var text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(title)
                .item()
            VStack(alignment: .leading, spacing: 5) {
                Text(text)
                    .itemRes()
                Text("ここでは予想される値段を表示しています。\n決済は配達完了後、支払料金が確定してから行われます。")
                    .caution1()
            }
            .offset(y: -2)
            Spacer()
        }
        .padding(.top, 20)
    }
}

struct ItemizationSomeCautionView: View {
    var title: String
    var text: String
    var caution: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(title)
                .item()
            VStack(alignment: .leading, spacing: 5) {
                Text(text)
                    .itemRes()
                Text(caution)
                    .caution1()
            }
            .offset(y: -2)
            Spacer()
        }
        .padding(.top, 20)
    }
}

struct ItemizationWithButtonView: View {
    var title: String
    var text: String
    var processing: () -> Void
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(title)
                .item()
            Text(text)
                .itemRes()
                .offset(y: -2)
            Spacer()
            Button(action: {processing()}, label: {
                Text("変更")
                    .miniAlernation()
            })
            
            
        }
        .padding(.top, 20)
    }
}

struct ItemizationCreditCardView: View {
    var title: String
    var text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(title)
                .item()
            Image(systemName: "creditcard")
            Text(text)
                .itemRes()
                .offset(y: -2)
            Spacer()
            Button(action: {PaymentStatus.shared.regPayModal = true}, label: {
                Text("変更")
                    .miniAlernation()
            })
            
            
        }
        .padding(.top, 20)
    }
}

struct ItemizationShowCreditCardView: View {
    var text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("決済方法")
                .item()
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Image(systemName: "creditcard")
                    Text(text)
                        .itemRes()
                }
                Text("買い物の依頼の際に変更できます。")
                    .caution1()
            }
            
            Spacer()
            
        }
        .padding(.top, 20)
    }
}
