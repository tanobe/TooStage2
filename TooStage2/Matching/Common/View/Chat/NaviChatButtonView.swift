//
//  NaviChatButtonView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/14.
//

import SwiftUI

struct NaviChatButtonView: View {
    
    @StateObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    
    func unread() -> Bool {
        if let matching = matching.data {
            if (shared.side() == "req" && matching.messages.filter({!$0.readReq}).count != 0) {
                // avoid infinite loops
                if !shared.naviActive {
                    shared.naviActive = true
                }
                return true
            }
            if (shared.side() == "und" && matching.messages.filter({!$0.readUnd}).count != 0) {
                // avoid infinite loops
                if !shared.naviActive {
                    shared.naviActive = true
                }
                return true
            }
            return false
        }
        
        return false
    }
    
    var body: some View {
        NavigationLink(destination: ChatView(), isActive: $shared.naviActive) {
            HStack(spacing: 10) {
                Image("Chatting")
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text("相手に連絡する")
                            .fontWeight(.semibold)
                            .font(.callout)
                        if unread() {
                            let _ = {shared.naviActive = true}
                            Text("未読")
                                .cautionYellow()
                        }
                    }
                    Text("依頼の変更やキャンセルはまずこちらから")
                        .font(.caption)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity)
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(5)
            .shadow1(radius: 5)
            .padding()
        }
    }
}
