//
//  NotificationView.swift
//  TooStage2
//
//
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        VStack {
            SimpleTitleView(title: "お知らせ")
            WebView(url: "https://too-toost.studio.site/news")
        }
        .background(Color("background").ignoresSafeArea())
    }
}
