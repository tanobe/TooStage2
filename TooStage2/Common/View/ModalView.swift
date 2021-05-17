//
//  ModalView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/11.
//

import SwiftUI

struct SampleModalView: View {
    @State var isOn = false
    var body: some View {
        VStack {
            Button(action: {
                self.isOn = true
            }, label: {
                Text("show modal")
            })
            Spacer()
        }
        .modalSheet(isPresented: $isOn) {
            MiniModalTwoChoicesView(
                text: "This is sample",
                annotation: "This is sample",
                leftButton: FuncMiniBorderButtonView(text: "back", processing: {
                    self.isOn = false
                }),
                rightButton: FuncMiniButtonView(text: "delete", processing: {
                    self.isOn = false
                })
            )
        }
    }
}

struct AnnotationRedView: View {
    var text: String
    var body: some View {
        HStack (alignment: .top) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.callout)
                .foregroundColor(Color("red1"))
                .frame(width: 20)
            Text(text)
                .caution2()
            Spacer()
        }
        .padding(.top, 5)
        .frame(maxWidth: .infinity)
    }
}

struct MiniModalTwoChoicesView<LBV: ButtonProtocol, RBV: ButtonProtocol>: View {
    /**
     * LBV means Left Button View
     * RBV means Right Button View
     * That button could have function, navigation, or warp
     */
    var text: String
    var annotation: String? = nil
    var leftButton: LBV
    var rightButton: RBV
    
    var body: some View {

        VStack(alignment: .leading) {
            
            VStack(alignment: .center) {
                Text(text)
                    .fontWeight(.bold)
                    .font(.title3)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
                
            if annotation != nil {
                HStack (alignment: .top) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.callout)
                        .foregroundColor(Color("red1"))
                        .frame(width: 20)
                    Text(annotation!)
                        .fontWeight(.medium)
                        .font(.caption)
                        .foregroundColor(Color("red1"))
                }
                .padding(.top, 5)
                .frame(maxWidth: .infinity)
                
            }
            
            HStack {
                leftButton
                rightButton
            }
            .padding(.top, 20)
                
        }
        .padding(30)
        .background(Color(.white))
        .frame(width: 300)
        .cornerRadius(10)
            
    }
}


struct MiniModalOneButtonView<BV: ButtonProtocol>: View {
    /**
     * LBV means Left Button View
     * RBV means Right Button View
     * That button could have function, navigation, or warp
     */
    var text: String
    var annotation: String? = nil
    var button: BV
    @Binding var isOn: Bool
    
    var body: some View {
        VStack {
            MiniDismissView(isOn: $isOn)
            VStack(alignment: .center) {
                Text(text)
                    .fontWeight(.bold)
                    .font(.title3)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
                
            if annotation != nil {
                Text(annotation!)
                    .font(.caption)
                    .padding(.top, 5)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
            
            button
                .padding(.top, 20)
                .padding(.horizontal)
                
        }
        .padding(.horizontal, 30)
        .padding(.top, 20)
        .padding(.bottom, 30)
        .background(Color(.white))
        .frame(width: 300)
        .cornerRadius(10)
            
    }
}


struct MiniModalMakeAnnouceView<BV: ButtonProtocol>: View {
    /**
     * LBV means Left Button View
     * RBV means Right Button View
     * That button could have function, navigation, or warp
     */
    var text: String
    var annotation: String? = nil
    var button: BV
    @Binding var isOn: Bool
    
    @Binding var selection: Int {
        didSet {
            if selection == 65 {
                selection = 5
            }
        }
    }
    
    let time = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
    
    var body: some View {

        VStack {
            MiniDismissView(isOn: $isOn)
            VStack(alignment: .center) {
                Text(text)
                    .fontWeight(.bold)
                    .font(.title3)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
                
            if annotation != nil {
                Text(annotation!)
                    .fontWeight(.light)
                    .font(.subheadline)
                    .padding(.top, 5)
                    .frame(maxWidth: .infinity)
            }
            VStack(alignment: .leading) {
                Text("アナウンスする時間を設定できます(5~60分)")
                    .fontWeight(.light)
                    .font(.caption)
                    .foregroundColor(Color("gray1"))
                
                HStack(alignment: .bottom) {
                    Picker(selection: $selection, label: Text("選択")) {
                        ForEach(time, id: \.self) { time in
                            Text("\(time)")
                                .fontWeight(.light)
                                .font(.caption)
                        }
                    }
                    .frame(width: 50, height: 30)
                    .clipped()
                    .cornerRadius(10)
                    .onTapGesture {
                        self.selection += 5
                    }
                    .animation(.default)
                    Text("分間アナウンスする")
                        .fontWeight(.light)
                        .font(.subheadline)
                        .padding(.bottom, 5)
                }
            }
            .padding(.top, 15)
            
            button
                .padding(.top, 20)
                .padding(.horizontal)
                
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
        .padding(.top, 15)
        .background(Color(.white))
        .frame(width: 300)
        .cornerRadius(10)
    }
}



struct ModalSheetViewModifier<V: View>: ViewModifier {
    var modalSheet: V
    @Binding var isOn: Bool
    var backTapDismiss: Bool
    var blur: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            
            content
            
            if blur {
                VisualEffectView(effect: UIBlurEffect(style: .light))
                    .edgesIgnoringSafeArea(.all)
            }
            
            if isOn {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                    
                    
                    .onTapGesture {
                        if backTapDismiss {
                            self.isOn = false
                        } else {
                            UIApplication.shared.closeKeyboard()
                        }
                    }
                
                modalSheet
            }
        }
    }
}

extension View {
    // this must be used in MainView
    func modalSheet<Content: View>(isPresented: Binding<Bool>, backTapDismiss: Bool = true, blur: Bool = false, content: @escaping () -> Content) -> some View {
        return self.modifier(ModalSheetViewModifier(modalSheet: content(), isOn: isPresented, backTapDismiss: backTapDismiss, blur: blur))
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
