//
//  ButtonView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/01/23.
//

import SwiftUI

// MARK: - Extension for make Buttom View
extension Text {
    
    // MARK: - regular
    // for decorate button
    func buttonDef(color: String) -> some View {
        return self
            .fontWeight(.semibold)
            .font(.title3)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(color))
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow1(radius: 5)
            .padding(.horizontal)
            .padding(.vertical, 10)
    }
    
    // MARK: - Little
    func buttonLittleDef(color: String) -> some View {
        return self
            .fontWeight(.semibold)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color(color))
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow1(radius: 5)
    }
    
//    func buttonLittleBorder(color: String) -> some View {
//        return self
//            .fontWeight(.semibold)
//            .font(.headline)
//            .frame(maxWidth: .infinity)
//            .padding(.vertical, 10)
//            .background(Color(.white))
//            .foregroundColor(Color(color))
//            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(color), lineWidth: 1))
//            .shadow1(radius: 5)
//    }
    
    func buttonMiniDef(color: String) -> some View {
        return self
            .fontWeight(.semibold)
            .font(.subheadline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Color(color))
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow1(radius: 5)
    }
    
    func buttonMiniBorder(color: String) -> some View {
        return self
            .fontWeight(.semibold)
            .font(.subheadline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Color(.white))
            .cornerRadius(10)
            .foregroundColor(Color(color))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(color), lineWidth: 1))
            .shadow1(radius: 5)
    }
}

// MARK: - Protocol

/**
 * You can only use these Button Views below
 * and cordinate it by extension func above
 */

protocol ButtonProtocol: View {}

func example() {
    print("example")
}

// MARK: - Button

/**
 * These Views are used like this
 *
 *
 * FuncButtonView(processing: example) {
 *     Text("a").buttonDef() as! Text
 * }
 *
 *
 * you must write 'as! Text' please
 *
 */


// Used by the situation where you want to run function when the user taped button
struct FuncButtonView: ButtonProtocol {

    var text: String
    var processing: () -> Void
    var color: String = "color1"
    
    var body: some View {
        Button(action: {
            processing()
        }, label: {
            Text(text).buttonDef(color: color)
        })
    }
}

// Used by the situation where you want to transition the screen to next View
struct NaviButtonView<V: View>: ButtonProtocol {

    var text: String
    var nextView: V
    var color: String = "color1"
    
    var body: some View {
        NavigationLink(
            destination: nextView
        ) {
            Text(text)
                .buttonDef(color: color)
        }
//        .buttonStyle(PlainButtonStyle())
    }
}

struct NaviFuncButtonView<V: View>: ButtonProtocol {
    var text: String
    var processing = non
    var nextView: V
    var color: String = "color1"
    
    var body: some View {
        NavigationLink(destination: nextView) {
            Text(text)
                .buttonDef(color: color)
        }.simultaneousGesture(TapGesture().onEnded{
            processing()
        })
    }
}

// MARK: - Little Button View

func non(){}

struct NaviLittleDefButtonView<V: View>: ButtonProtocol {
    var text: String
    var processing = non
    var nextView: V
    var color: String = "color1"
    
    var body: some View {
        NavigationLink(destination: nextView) {
            Text(text)
                .buttonLittleDef(color: color)
        }.simultaneousGesture(TapGesture().onEnded{
            processing()
        })
    }
}

struct FuncLittleBorderButtonView: ButtonProtocol {
    var text: String
    var processing: () -> Void
    var color: String = "color1"
    
    var body: some View {
        Button(action: {
            processing()
        }, label: {
            HStack {
                Text(text)
                    .fontWeight(.semibold)
                Image(systemName: "megaphone.fill")
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color(.white))
            .cornerRadius(10)
            .foregroundColor(Color(color))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(color), lineWidth: 1))
            .shadow1(radius: 5)
        })
    }
}



// MARK: - Mini Button View

// Used by the situation where you want to run function when the user taped button
struct FuncMiniButtonView: ButtonProtocol {
    var text: String
    var processing: () -> Void
    var color: String = "color1"
    
    var body: some View {
        Button(action: {
            processing()
        }, label: {
            Text(text).buttonMiniDef(color: color)
        })
    }
}

struct FuncMiniBorderButtonView: ButtonProtocol {

    var text: String
    var processing: () -> Void
    var color: String = "color1"
    
    var body: some View {
        Button(action: {
            processing()
        }, label: {
            Text(text).buttonMiniBorder(color: color)
        })
    }
}

// Used by the situation where you want to transition the screen to next View
struct NaviMiniButtonView<V: View>: ButtonProtocol {
    
    @Binding var isOn: Bool
    var text: String
    var nextView: V
    var color: String = "color1"
    
    var body: some View {
        NavigationLink(destination: nextView) {
            Text(text)
                .buttonDef(color: color)
        }.simultaneousGesture(TapGesture().onEnded{
            self.isOn = false
        })
        .buttonStyle(PlainButtonStyle())
    }
}

struct NaviMiniDefButtonView<V: View>: ButtonProtocol {
    var text: String
    var processing = non
    var nextView: V
    var color: String = "color1"
    
    var body: some View {
        NavigationLink(destination: nextView) {
            Text(text)
                .buttonMiniDef(color: color)
        }.simultaneousGesture(TapGesture().onEnded{
            processing()
        })
    }
}

// Used by the situation where you want to warp to Other view that is out of the NavigationView
struct WarpMiniButtoView: View {
    var body: some View {
        VStack{}
    }
}

