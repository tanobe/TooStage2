//
//  PrivacyPolicyView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/22.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleView(present: presentationMode, title: "プライバシー・ポリシー")
            WebView(url: "https://toostage2-27899.web.app/privacy-policy.html")
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
    }
}
