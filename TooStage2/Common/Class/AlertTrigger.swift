//
//  SwiftUIView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/26.
//

import SwiftUI

class AlertTrigger: ObservableObject {
    
    static let shared = AlertTrigger()
    
    // for registration stripe account
    @Published var failureOnbording = false
    @Published var onboardingNotFinished = false
    
    // for checking the value of reward
    @Published var rewardAlert = false
}
