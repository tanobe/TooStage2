//
//  Spotlight.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/21.
//

import SwiftUI

class Spotlight: ObservableObject {
    
    static let shared = Spotlight()
    
    init() {
        self.light()
    }
    
    @Published var isOn = false
    
    func light() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.isOn.toggle()
        }
    }
    
}
