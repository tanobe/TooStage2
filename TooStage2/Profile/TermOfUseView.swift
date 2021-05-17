//
//  TermOfUseView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/10.
//

import SwiftUI

struct TermOfUseView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleView(present: presentationMode, title: "利用規約")
            WebView(url: "https://toostage2-27899.web.app/term-of-use.html")
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
    }
}
