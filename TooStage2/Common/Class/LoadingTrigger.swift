//
//  LoadingTrigger.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/26.
//

import SwiftUI

class LoadingTrigger: ObservableObject {
    static let shared = LoadingTrigger()
    @Published var isOn = false
}
