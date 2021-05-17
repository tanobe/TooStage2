//
//  MessagesView.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/04.
//

import SwiftUI

struct MessagesView: View {
    @StateObject var chatData = Flag.shared
    @StateObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            if let data = matching.data {
                Text(data.regTime.convertToHHmm())
                    .caution3()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
            }
            if let matching = matching.data {
                ForEach(matching.messages, id: \.self) { data in
                    if(data.uid == UserStatus.shared.uid!) {
                        MyMessage(data: data)
                    } else {
                        HisMessage(data: data)
                    }
                }
                .padding(.top, 10)
                .onAppear {
                    self.shared.didReadAll()
                }
            }
        }
        .background(Color("background"))
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
    }
}
