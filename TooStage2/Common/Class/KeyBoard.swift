//
//  KeyBoard.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/02.
//

import SwiftUI

// アプリケーションの大元クラス
// keyboardのClose処理をextentionした
extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
