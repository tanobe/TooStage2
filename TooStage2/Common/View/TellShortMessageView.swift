//
//  TellShortMessageView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/27.
//

import SwiftUI

struct TellShortMessageView: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .fontWeight(.semibold)
            .font(.subheadline)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color.white)
            .cornerRadius(10)
    }
    
}
