//
//  TitleView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/11.
//

import SwiftUI

struct TitleView: View {
    @Binding var present: PresentationMode
    var title: String
    var body: some View {

            HStack {
                Button {
                    self.present.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(Font.title2.weight(.bold))
                        .foregroundColor(Color("color1"))

                }

                
                
                Spacer()
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("color1"))
                
                Spacer()
                Text("　")
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 30)
        
    }
}

struct SimpleTitleView: View {
    var title: String
    var body: some View {

            HStack {
                
                
                
                Spacer()
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("color1"))
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 30)
        
    }
}


struct ModalTitleView: View {
    @Binding var isOn: Bool
    var title: String
    var body: some View {
        HStack {
            Text(" ")
            Spacer()
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color("color1"))
            Spacer()
            Button(action: {isOn = false}, label: {
                Image(systemName: "multiply")
                    .foregroundColor(Color( "color1"))
                    .font(.title3)
                    .frame(width: 20, height: 20, alignment: .trailing)
            })
        }
    }
}

struct MatchingTitleView: View {
    var title: String
    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color("color1"))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
//                .padding(.top, 10)
//                .padding(.bottom, 10)
                .padding(.top, 20)
                .padding(.bottom, 30)
            Spacer()
        }
    }
}
