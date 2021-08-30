//
//  ContentView.swift
//  TooStage2
//
// 
//

import SwiftUI

struct ContentView: View {
    
    @State var someView = TabList.map
    
    // Auth AddListener, must be here
    @StateObject private var authManager = AuthManager()
    
    @ObservedObject var shops = Shops.shared.shops
    @StateObject var status = UserStatus.shared
    @StateObject var userData = UserData.shared
    @StateObject var shopDetail = ShopDetail.shared
    
    init() {
        Location.shared.push(lat: LocationManager.shared.userLatitude, lon: LocationManager.shared.userLongitude)
    }
    
    func isReq(mid: String) -> Bool {
        let reqUserId = mid.prefix(28)
        if reqUserId == status.uid ?? "nil" {
            return true
        } else {
            return false
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                // slected view at tab view
                if self.someView == TabList.map {
                    MapView(status: $someView)
                } else if someView == TabList.my {
                    ProfileView()
                } else if someView == TabList.ano {
                    NotificationView()
                }
                
                // custom tab view
                VStack {
                    Spacer(minLength: 0)
                    CustomTabView(status: $someView)
                }
                
                // show CompleteInfoView
                if status.token == "signed" {
                    CompleteInfoView(info: CompleteInfo())
                }
                
                // show fixed RequestView
                if let rid = userData.data?.requestId {
                    if rid != "" {
                        FixRequestView()
                    }
                }
                
                // show fixed MatchingView
                if let mid = userData.data?.matchingId {
                    if mid != "" {
                        if isReq(mid: mid) {
                            MatchingRequestView()
                        } else {
                            let _ = print("called called called")
                            MatchingUndertakeView()
                        }
                    }
                }
                
            }
            .edgesIgnoringSafeArea(.bottom)
            // shop detail
            .mutableSheet(isPresented: $shopDetail.isOn, offset: $shopDetail.offset, height: UIScreen.main.bounds.height * 3 / 4) {
                VStack {
                    // User status must be completed
                    if UserStatus.shared.token == "completed" {
                        if shopDetail.shop != nil {
                            MapSubView()
                        }
                    } else {
                        EncourageRegistrationView(lavel: "リクエスト\n　　アナウンス")
                    }
                }
            }
            // start annouce
            .modalSheet(isPresented: $shopDetail.annRegisterIsOn) {
                MiniModalMakeAnnouceView(
                    text: "このお店に買い物に行くアナウンスをしますか？",
                    annotation: "アナウンスすると依頼されやすくなります。依頼があれば引き受けてみてください。アナウンスは削除できません。",
                    button: FuncMiniButtonView(
                        text: "アナウンス開始",
                        processing: {
                            shopDetail.annRegister(mm: shopDetail.time)
                            /** show done message to user  */
                            shopDetail.annIsOnFalse()
                        }),
                    isOn: $shopDetail.annRegisterIsOn,
                    selection: $shopDetail.time
                )
            }
            
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


// MARK: - Custom Tab
enum TabList: String {
    case map
    case my
    case ano
}


struct CustomTabView: View {

    @Binding var status: TabList

    var body: some View {
        ZStack {
            
            GradationBackgroundColor()
            
            HStack {
                
                    Spacer()
                
                    Button(action: {
                        self.status = TabList.my
                    }, label: {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()//縦横比を保つためのもの
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color("color1"))
                    })
                
                    Spacer()
                
                    Button(action: {
                        self.status = TabList.map
                        // set
                        Location.shared.push(lat: LocationManager.shared.userLatitude, lon: LocationManager.shared.userLongitude)
                        
                    }, label: {
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding(17)
                            .foregroundColor(.white)
                            .background(Color("color1"))
                            .clipShape(Circle())
                    })
                
                    Spacer()
                
                    Button(action: {
                        self.status = TabList.ano
                    }, label: {
                        ZStack {
                            Image(systemName: "bell.fill")
                                .resizable()
                                .scaledToFit()//縦横比を保つためのもの
                                .frame(width: 26, height: 26)
                                .foregroundColor(Color("color1"))
                            
                        }
                    })
                    Spacer()
            }
        }
    }
}


struct GradationBackgroundColor: View {
    var body: some View {
        Rectangle()
        .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 0.77, green: 0.77, blue: 0.77, opacity: 0), Color(red: 0.98, green: 0.93, blue: 0.59, opacity: 0.37), Color(red: 0.67, green: 0.93, blue: 0.84)]), startPoint: .top, endPoint: .bottom))
        .frame(maxWidth: .infinity, maxHeight: 102)
        .padding(.top, 22)
        .frame(maxWidth: .infinity, maxHeight: 124)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
