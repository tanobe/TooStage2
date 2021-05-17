//
//  ProfileView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/03.
//

import SwiftUI
import FirebaseAuth

struct ShowModalProfileColumnView: View {
    @Binding var isOn: Bool
    var body: some View {
        Button(action: {
            self.isOn = true
        }, label: {
            HStack {
                Text("サインアウト")
                    .foregroundColor(Color("color1"))
                Spacer()
            }
            .padding(.top, 10)
        })
        Divider()
    }
}

struct VersionProfileColumnView: View {
    
    @State var count = 0
    @State var navi = false
    
    var body: some View {
        Button(action: {
            self.count += 1
            if count == 2 {
                self.count = 0
                self.navi = true
            }
        }, label: {
            HStack {
                Text("バージョン")
                    .foregroundColor(Color("color1"))
                Spacer()
                Text("closed beta")
                    .foregroundColor(Color("gray1"))
            }
            .padding(.top, 10)
        })
        .background(
            NavigationLink(destination: SecretView(), isActive: $navi) { EmptyView() }
        )

        Divider()
    }
}

struct NaviProfileColumnView<V: View>: View {
    var title: String
    var next: V
    var body: some View {
        NavigationLink (destination: next) {
            HStack {
                Text(title)
                    .foregroundColor(Color("color1"))
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("gray5"))
            }
            .padding(.top, 10)
        }
        Divider()
    }
}

struct ProfileEvaluation: Codable {
    var mid: String
    var value: Int
}

struct EvaluateArr: Codable {
    var id: String
    var values: [ProfileEvaluation]
}

struct ProfileContentView: View {
    
    @ObservedObject var evaluationDoc = FirestoreGetDocument<EvaluateArr>(collection: "users/\(UserStatus.shared.uid!)/evaluation", doc: "value")
    @ObservedObject var userData = UserData.shared
    
    @State var showSignoutModal = false
    
    var averageValue: Float {
        var i: Float = 0
        guard let data = evaluationDoc.data else {
            return i
        }
        for ev in data.values {
            i += Float(ev.value)
        }
        i /= Float(data.values.count)
        return i
    }
    
    func moreOrLess(_ n: Int) -> Bool {
        if Float(n) <= round(averageValue) {
            return true
        } else {
            return false
        }
    }
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            VStack {
                if let fName = userData.data?.familyName,
                   let gName = userData.data?.givenName {
                    Text(fName + " " + gName)
                        .font(.title3)
                        .foregroundColor(Color("color1"))
                        .padding(.vertical)
                }

                VStack(spacing: 5) {
                    Text(String(format: "%.1f", averageValue))
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(moreOrLess(1) ? Color("color3") : Color(.gray))
                        Image(systemName: "star.fill")
                            .foregroundColor(moreOrLess(2) ? Color("color3") : Color(.gray))
                        Image(systemName: "star.fill")
                            .foregroundColor(moreOrLess(3) ? Color("color3") : Color(.gray))
                        Image(systemName: "star.fill")
                            .foregroundColor(moreOrLess(4) ? Color("color3") : Color(.gray))
                        Image(systemName: "star.fill")
                            .foregroundColor(moreOrLess(5) ? Color("color3") : Color(.gray))
                    }
                    .padding(.bottom)
                }
                
            }
            .padding(.top, 60)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .cornerRadius(10)
            .background(Color("background"))

            ScrollView {
                VStack(spacing: 50) {
                    NavigationLink(destination: QuestionnaireView()) {
                        HStack(spacing: 10) {
                            Image("Chatting")
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text("アンケートのお願い")
                                        .fontWeight(.semibold)
                                        .font(.callout)
                                }
                                Text("ギフト券500円分をプレゼント！")
                                    .font(.caption)
                            }
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow1(radius: 5)
                    }
                    
                    VStack {
                        NaviProfileColumnView(title: "個人情報", next: PersonalInfomationView())
                        NaviProfileColumnView(title: "取引履歴", next: MatchingHistoryView())
                    }
                    VStack {
                        NaviProfileColumnView(title: "銀行口座に入金", next: PayoutView())
                        NaviProfileColumnView(title: "入金履歴", next: PayoutHistoryView())
                    }
                    VStack {
                        NaviProfileColumnView(title: "お問い合わせ", next: ContactView())
                        NaviProfileColumnView(title: "利用規約", next: TermOfUseView())
                        NaviProfileColumnView(title: "プライバシー・ポリシー", next: PrivacyPolicyView())
                        ShowModalProfileColumnView(isOn: $showSignoutModal)
                    }
                    VStack {
                        VersionProfileColumnView()
                    }
                }
                .padding(.horizontal, 50)
                .padding(.bottom, 150)
                .padding(.top, 30)
            }

        }
        .background(Color("background"))
        .ignoresSafeArea()
        .modalSheet(isPresented: $showSignoutModal) {
            MiniModalOneButtonView(
                text: "サインアウトしますか？",
                button: FuncMiniButtonView(
                    text: "はい",
                    processing: {
                        do {
                            try Auth.auth().signOut()
                            UserStatus.shared.signOut()
                        } catch {
                            print("Error")
                        }
                    }),
                isOn: $showSignoutModal)
        }
    }
}

struct OnProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("mypage")
                
                Button(action: {
                    do {
                        try Auth.auth().signOut()
                        
                        // sign out func
                        UserStatus.shared.signOut()
                    } catch {
                        print("Error")
                    }
                }, label: {
                    Text("sign out")
                })
            }
        }
    }
}

struct OffProfileView: View {
    var body: some View {
        EncourageRegistrationView(lavel: "マイページ")
    }
}

struct ProfileView: View {
    @ObservedObject var status = UserStatus.shared
    var body: some View {
        if status.token == nil || status.token == "signed" {
            OffProfileView()
        } else {
            ProfileContentView()
        }
    }
}
