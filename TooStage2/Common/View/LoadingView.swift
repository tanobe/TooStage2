//
//  LoadingView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/26.
//

import SwiftUI

// you can use like this
struct LoadingSampleView: View {
    
    @State var isOn: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                self.isOn = true
            }, label: {
                Text("Button")
            })
        }
        .loading(isPresented: $isOn)
    }
}

struct LoadingViewModifier: ViewModifier {

    @Binding var isOn: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isOn {
                ZStack {
                    Color.white.opacity(0.0001)
                        .ignoresSafeArea()
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
        }
    }
}

extension View {
    func loading(isPresented: Binding<Bool>) -> some View {
        return self.modifier(LoadingViewModifier(isOn: isPresented))
    }
}
