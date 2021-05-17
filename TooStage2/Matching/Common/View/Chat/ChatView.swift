//
//  TextFieldView.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/04.
//

import SwiftUI

//MARK: - This is a flag for TextField

class Flag: ObservableObject {
    
    static let shared = Flag()
    
    @Published  var name = ""
    @Published  var editFlag = false
    @Published  var endFlag = false
}

//MARK: - ChatView
struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var chatData = Flag.shared
    @ObservedObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    var messagesDict: [String: Any] {
        return ["messages": self.matching.data!.messages.map({$0.dictionary})]
    }
    
    var body: some View {
        VStack {
            TitleView(present: presentationMode, title: "チャット")
            MessagesView()
            HStack(spacing: 15) {
                TextField(
                    "相手へのメッセージ",
                    text: $chatData.name,
                    onEditingChanged: { begin in
                        print("onEditingChangedfirst \(begin)")
                        if begin {
                            self.chatData.editFlag = true
                        } else {
                            print("onEditingChanged \(begin)")
                            self.chatData.editFlag = false  // 編集フラグをオフ
                        }
                    }
                )
                
                
                
                if !chatData.name.isEmpty {
                    Button(action: {
                        let newMessage = Message(
                            time: Date().dateToString(),
                            message: self.chatData.name,
                            uid: UserStatus.shared.uid!,
                            readReq: self.shared.side() == "req" ? true: false,
                            readUnd: self.shared.side() == "und" ? true: false)
                        self.matching.data?.messages.append(newMessage)
                        self.matching.updateDocument(
                            doc: self.matching.data!.id,
                            data: messagesDict)
                        self.chatData.name = ""  //　入力域をクリア
                        self.chatData.endFlag = true
                    }, label: {
                        Image(systemName: "paperplane")
                            .foregroundColor(Color("color1"))
                            .font(.title2)
                    })
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
            .background(Color.white)
        }
        .navigationBarHidden(true)
    }
}

