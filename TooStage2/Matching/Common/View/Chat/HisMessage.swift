//
//  HisMessage.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/04.
//

import SwiftUI

struct HisMessage: View {
    var data: Message
    var body: some View {
        VStack(spacing: 15) {
            Text(data.time.convertToHHmm())
                .caution3()
            HStack {
                VStack {
                    Text(data.message)
                        .foregroundColor(.white)
                        .font(.callout)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color("color1"))
                        .cornerRadius(30)
                        .frame(width: 270, alignment: .leading)
                        .shadow(color: Color("yellow3"),
                                radius: 10,
                                x: CGFloat(3),
                                y: CGFloat(3))
                }
                Spacer()
            }
        }
        .padding(.bottom, 30)
        .padding(.horizontal)
    }
}
