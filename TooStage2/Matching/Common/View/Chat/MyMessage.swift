//
//  MyMessage.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/04.
//

import SwiftUI

struct MyMessage: View {
    var data: Message
    var body: some View {
        VStack(spacing: 15) {
            Text(data.time.convertToHHmm())
                .caution3()
            HStack {
                Spacer()
                VStack {
                    Text(data.message)
                        .foregroundColor(Color("color1"))
                        .font(.callout)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(30)
                        .frame(width: 270, alignment: .trailing)
                        .shadow(color: Color("color5"),
                                radius: 10,
                                x: CGFloat(3),
                                y: CGFloat(3))
                }
            }
        }
        .padding(.bottom, 30)
        .padding(.horizontal)
    }
}

