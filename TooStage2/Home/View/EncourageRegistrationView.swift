//
//  EncourageRegistrationView.swift
//  TooStage2
//
// 
//

import SwiftUI
import GoogleSignIn

struct EncourageRegistrationView: View {

    var lavel: String
    
    var body: some View {
        VStack {
            
            Text(lavel)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            VStack(spacing: 20) {
                Button(action: {
                    GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
                    GIDSignIn.sharedInstance()?.signIn()
                }, label: {
                    Image("googleLogin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .shadow(radius: 3)
                })
                VStack(spacing: 15) {
                    NavigationLink(destination: TermOfUseView(), label: {
                        Text("利用規約")
                            .buttonTermOfUse()
                    })
                    Text("ログインする前に利用規約をご確認ください。")
                        .caution1()
                        .multilineTextAlignment(.center)
                }

            }
        }
//        .ignoresSafeArea()
        .offset(y: -50)
    }
}

extension Text {
    func buttonTermOfUse() -> some View {
        return self
            .fontWeight(.semibold)
            .font(.title3)
            .frame(width: 198, height: 50)
            .background(Color.white)
            .cornerRadius(100)
            .foregroundColor(Color("color1"))
            .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color("color1"), lineWidth: 1))
            .shadow1(radius: 5)
    }
}
