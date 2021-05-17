//
//  RegistrationPaymentAccountView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/24.
//

import SwiftUI

struct RegistrationCreditCardView: View {
    
    @Binding var isOn: Bool

    var body: some View {
        VStack {
            
            VStack {
                MiniDismissView(isOn: $isOn)
                Text("クレジットカード登録")
                    .fontWeight(.bold)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                Text("最後にクレジットカードを登録します。\nこれで初回登録は完了です。")
                    .font(.caption)
                    .padding(.top, 5)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 30)
            
            PayViewController()
            
            
        }
        .padding(.bottom, 30)
        .padding(.top, 15)
        .background(Color.white)
        .frame(width: 300, height: 300)
        .cornerRadius(10)
    }
}

struct UpdateCreditCardView: View {
    
    @Binding var isOn: Bool

    var body: some View {
        VStack {
            
            VStack {
                MiniDismissView(isOn: $isOn)
                Text("クレジットカード更新")
                    .fontWeight(.bold)
                    .font(.title3)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 30)
            
            PayViewController()
            
        }
        .padding(.bottom, 30)
        .padding(.top, 15)
        .background(Color.white)
        .frame(width: 300, height: 250)
        .cornerRadius(10)
    }
}

