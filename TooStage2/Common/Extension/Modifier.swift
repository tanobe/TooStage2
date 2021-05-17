//
//  Modifier.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/11.
//

import SwiftUI

// MARK: - shadow

extension View {
    func shadow1(radius: CGFloat) -> some View {
        self
            .shadow(color: Color("shadow1"), radius: radius)
    }
}

// MARK: - Text
extension Text {
    
    func head() -> some View {
        self
            .fontWeight(.bold)
            .font(.headline)
            .multilineTextAlignment(.center)
    }
    
    func caution2(color: Color = Color("red1")) -> some View {
        self
            .fontWeight(.medium)
            .font(.caption)
            .foregroundColor(color)
    }
    
    func caution3() -> some View {
        self
            .font(.caption)
            .fontWeight(.light)
            .foregroundColor(Color("purple1"))
    }
    
    func subTitle() -> some View {
        self
            .fontWeight(.medium)
            .font(.callout)
            .foregroundColor(Color("color2"))
    }
    
    func title3Color() -> some View {
        self
            .fontWeight(.bold)
            .font(.title3)
            .multilineTextAlignment(.center)
            .foregroundColor(Color("color1"))
    }
    
    func comment() -> some View {
        self
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .foregroundColor(Color("color1"))
    }
    
    func subTitle2() -> some View {
        self
            .fontWeight(.medium)
            .font(.callout)
            .foregroundColor(Color("color3"))
    }
    
    func miniAlernation() -> some View {
        self
            .fontWeight(.bold)
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color("color3"))
            .cornerRadius(10)
    }
    
    func cautionYellow() -> some View {
        self
            .fontWeight(.semibold)
            .font(.caption2)
            .foregroundColor(Color("color2"))
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color("yellow1"))
            .cornerRadius(10)
    }
    
    func reqSide() -> some View {
        self
            .fontWeight(.semibold)
            .font(.caption2)
            .foregroundColor(Color.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color("color3"))
            .cornerRadius(10)
    }
    
    func undSide() -> some View {
        self
            .fontWeight(.semibold)
            .font(.caption2)
            .foregroundColor(Color("color2"))
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color("yellow1"))
            .cornerRadius(10)
    }
    
    func canSide() -> some View {
        self
            .fontWeight(.semibold)
            .font(.caption2)
            .foregroundColor(Color.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color("gray1"))
            .cornerRadius(10)
    }

    
    func AorB(isColor: Bool) -> some View {
        self
            .fontWeight(.bold)
            .font(.caption)
            .frame(width: 40)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .foregroundColor(isColor ? .white : Color("color3"))
            .background(isColor ? Color("color3") : .white)
            .cornerRadius(10)
            
    }
    
    func item() -> some View {
        self
            .fontWeight(.bold)
            .font(.footnote)
            .foregroundColor(Color("color3"))
    }
    
    func itemRes() -> some View {
        self
            .fontWeight(.bold)
            .font(.callout)
    }
    
    func caution1() -> some View {
        self
            .font(.caption)
            .fontWeight(.light)
            .foregroundColor(Color("gray3"))
    }
    
    func unbought() -> some View {
        self
            .fontWeight(.bold)
            .font(.caption2)
            .padding(.horizontal, 13)
            .padding(.vertical, 7)
            .foregroundColor(.white)
            .background(Color("gray6"))
            .cornerRadius(100)
    }
    
    func bought() -> some View {
        self
            .fontWeight(.bold)
            .font(.caption2)
            .padding(.horizontal, 13)
            .padding(.vertical, 7)
            .foregroundColor(.white)
            .background(Color("color2"))
            .cornerRadius(100)
    }
}

// MARK: - For Matching
extension Text {
    
    func stateText() ->  some View {
    self
        .fontWeight(.medium)
        .font(.subheadline)
        .multilineTextAlignment(.center)
        .foregroundColor(Color("black"))
    }
}

// Extension for CircleImage


// EllipseColor
extension Ellipse {
    func EllipseColor(_ color: Color = .blue) ->some View {
        return self
            .fill(color)
            .frame(width: 36, height: 36)
    }
}


//  RectangleColor
extension Rectangle {
    func RectangleColor(_ color: Color = .gray) ->some View {
        return self
            .fill(color)
            .frame(width: 18, height: 3)
    }
}


// MARK: - keyboard
extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// 半角数字の判定
extension String {
    func isAlphanumeric() -> Bool {
        self.range(of: "[^0-9]+", options: .regularExpression) == nil && self != ""
    }
}
