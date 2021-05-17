//
//  QuestionnaireView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/23.
//

import SwiftUI

struct QuestionnaireView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleView(present: presentationMode, title: "アンケート")
            VStack(alignment: .leading, spacing: 5) {
                Text("回答締め切り：2021年6月30日（水）23:59")
                Text("回答所要時間：5分程度")
                Text("アンケートにご協力頂いた方の中から、抽選で30名様にお好きなギフト券(Eメールタイプ)をプレゼント致します。")
                    .fontWeight(.semibold)
                Text("迷惑メールブロックなどを設定されている方は「too.for.us@gmail.com」からのメールを受信できるよう設定をお願い致します。")
                Text("アンケートは予告なく、変更、終了する場合がございますので、予めご了承ください。")
                Text("多くの皆様にご協力頂ければ幸いです。これからもtooをよろしくお願い致します。")
            }
            .padding(15)
            .background(Color("gray2"))
            .cornerRadius(10)
            .font(.caption)
            .padding(.horizontal)
            WebView(url: "https://forms.gle/G3rV6UKTKp2JswAP6")
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
    }
}
