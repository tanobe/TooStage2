//
//  SecretView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/08.
//

import SwiftUI

struct SecretView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            TitleView(present: presentationMode, title: "Hi!")
            CreatedByView()
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
    }
}

struct CreatedByView: View {
    
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 15) {
                Text("Created by")
                    .font(.headline)
                    .fontWeight(.bold)
                VStack(spacing: 5) {
                    Text("okasako misaki")
                    Text("neki sakika")
                    Text("sakai keito")
                    Text("seto yuta")
                    Text("tanobe kai")
                    Text("wang yuanfan")
                }
            }
            Spacer()
        }
        .offset(y: -50)
    }
}
