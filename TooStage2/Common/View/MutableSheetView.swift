//
//  MutableSheet.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/02.
//

import SwiftUI

// this is sumple view using mutableSheet modifier
struct ParentView: View {
    @State var isOn = false
    @State var offset: CGFloat = UIScreen.main.bounds.height
    var body: some View {
        VStack {
            Button(action: {
                self.isOn = true
                self.offset = 0

            }, label: {
                Text("show sheet")
            })
        }
        .mutableSheet(isPresented: $isOn, offset: $offset, height: 400) {
            ChildSheetView()
        }
    }
}

struct ChildSheetView: View {
    var body: some View {
        Text("child sheet view")
    }
}

struct MutableSheetViewModifier<V: View>: ViewModifier {
    
    var sheetContentView: V
    @Binding var isOn: Bool
    @Binding var offset: CGFloat
    var height: CGFloat
    var color: Color

    func body(content: Content) -> some View {
        ZStack {
            
            content

            VStack {
                Spacer()
                sheetContentView
                    .frame(width: UIScreen.main.bounds.width, height: height)
                    .background(color)
                    .cornerRadius(25, corners: [.topLeft, .topRight])
                    .offset(y: self.offset)
                    .gesture(
                        DragGesture()
                            // while the finger is attached
                            .onChanged({ value in
                                if value.translation.height > 0 {
                                    self.offset = value.location.y
                                }
                            })
                            // when the finger is apart
                            .onEnded({ value in
                                if self.offset > (height / 3) {
                                    self.offset = UIScreen.main.bounds.height
                                    self.isOn = false
                                } else {
                                    self.offset = 0
                                    self.isOn = true
                                }
                            })
                    )
                
            }
            .shadow1(radius: 10)
            .animation(.default)
            .background((isOn ? Color.white.opacity(0.01) : Color.clear)
                            .ignoresSafeArea()
                            .onTapGesture {
                                self.isOn = false
                                self.offset = UIScreen.main.bounds.height})
            .ignoresSafeArea()
        }
    }
}

extension View {
    func mutableSheet<Content: View>(isPresented: Binding<Bool>,
                                     offset: Binding<CGFloat>,
                                     height: CGFloat,
                                     color: Color = .white,
                                     content: @escaping () -> Content) -> some View
    {
        return self.modifier(MutableSheetViewModifier<Content>(sheetContentView: content(), isOn: isPresented, offset: offset, height: height, color: color))
    }
}



struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
