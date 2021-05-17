//
//  MiniDismissView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/24.
//

import SwiftUI

struct MiniDismissView: View {
    @Binding var isOn: Bool
    var color: Color = Color("color1")
    var body: some View {
        HStack {
            Spacer()
            Button(action: {isOn = false}, label: {
                Image(systemName: "multiply")
                    .foregroundColor(color)
                    .font(.title3)
                    .frame(width: 20, height: 20, alignment: .trailing)
            })
        }
        .padding(.bottom, 5)
    }
}
