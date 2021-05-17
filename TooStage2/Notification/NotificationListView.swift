//
//  NotificationListView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/22.
//

//import SwiftUI
//
//struct NotificationToUser: Codable, Identifiable, Equatable {
//    var id: String
//    var time: String
//    var description: String
//    var read: Bool
//}
//
//struct NotificationColumnView: View {
//    var data :NotificationToUser
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 10) {
//                Text(data.time)
//                    .font(.subheadline)
//                Text(data.description)
//                    .font(.callout)
//                    .fontWeight(.bold)
//            }
//            Spacer()
//        }
//        .padding()
//    }
//}
//
//
//struct NotificationListView: View {
//    
//    @ObservedObject var notificatons = FireStoreGetList<NotificationToUser>(collection: "users/\(UserStatus.shared.uid ?? "nil")/notifications")
//    
//    var body: some View {
//        VStack {
//            SimpleTitleView(title: "お知らせ")
//            List {
//                if notificatons.list.count != 0 {
//                    ForEach(notificatons.list.sorted(by: {$0.time > $1.time})) { notif in
//                        NotificationColumnView(data: notif)
//                    }
//                } else {
//                    VStack {
//                        HStack {
//                            Text("お知らせはありません")
//                                .subTitle()
//                            Spacer()
//                        }
//                        Spacer()
//                    }
//                }
//                
//            }
//            
//        }
//        .background(Color("background").ignoresSafeArea())
//    }
//}
