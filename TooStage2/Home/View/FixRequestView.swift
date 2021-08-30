//
//  FixRequestView.swift
//  TooStage2
//
// 
//

import SwiftUI

struct FixRequestView: View {
    
    @State var deleteIsOn = false
    @ObservedObject var request: FirestoreGetDocument<Request>
    
    @State var timeLimit: String = ""
    
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.timeLimit = request.data?.regTime.stringToDate().advanceTheTimeHH(1).dateToString().calcTimeLimitmmss() ?? ""
        }
    }
    
    let sid: String
    
    init() {
        // requestId is requestUserId + date + sid
        let rid = UserData.shared.data!.requestId
        let startIndex = rid.index(rid.startIndex, offsetBy: 42)
        let endIndex = rid.index(rid.endIndex, offsetBy: -1)
        self.sid = String(rid[startIndex...endIndex])
        print("sid: \(sid)")
        self.request = FirestoreGetDocument<Request>(collection: "shops/\(sid)/requests", doc: rid)
    }
    
    var body: some View {
        ZStack {
            Color("color1").opacity(0.7)
                .ignoresSafeArea()
            VStack {
                
                Image("Thinking")
                    .padding(.bottom, 40)
                
                VStack(spacing: 10) {
                    Text("ついでに買いに行く方を探しています...\n見つかり次第通知します。")
                        .head()
                        .foregroundColor(.white)
                    Text("別の依頼を作りたい場合には、\nキャンセルしてください。\n複数の依頼への対応も\n今後アップデートしてまいります。")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("自動キャンセルまで、あと\(timeLimit)")
                        .caution2(color: .white)
                        .onAppear(perform: {
                            _ = self.timer
                        })
                        
                }
                .padding(.bottom, 40)
                
                VStack {
                    FuncMiniBorderButtonView(text: "依頼をキャンセル", processing: {
                        self.deleteIsOn = true
                    })
                    /**  --
                     * whats?
                     */
                    //.padding(.bottom, 10)
                    
                    // Content->RequestConfirmationViewまで
                    // (RequestConfirmationViewのキャッシュを残しておく)
                    // ようにすればできる？アプリが閉じたらどうなる？
                    
//                    FuncMiniButtonView(text: "依頼を編集", processing: {
//                        non()
//                    // ↑ NaviMiniButtonView
//                    })
                }
                .frame(width: 250)
            }
            .offset(y: -50)
        }
        .modalSheet(isPresented: $deleteIsOn) {
            MiniModalTwoChoicesView(
                text: "依頼を削除しますか",
                leftButton: FuncMiniBorderButtonView(text: "いいえ", processing: {
                    self.deleteIsOn = false
                }),
                rightButton: FuncMiniButtonView(text: "はい", processing: {
                    self.deleteIsOn = false
                    // shop/[sid]/request/reqid のvalidity = false
                    FirestoreUpdate(collection: "shops/\(sid)/requests").update(document: UserData.shared.data!.requestId, data: ["validity": false])
                    // userData変更 reqid = ""
                    UserData.shared.updateDocument(data: ["requestId": ""])
                    // delete the job in cloud schedule
                    let jobName = request.data?.id ?? ""
                    Webhook.shared.post(url: "firebaseModule-deleteTheJob", body: ["jobName": jobName])
                })
            )
        }
    }
}
