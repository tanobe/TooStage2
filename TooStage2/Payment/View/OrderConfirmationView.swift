//
//  OrderConfirmationView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/02/04.
//

import SwiftUI
import UIKit
import SafariServices



struct PayView: View {
    var body: some View {
        PayViewController()
    }
}

struct PayViewController: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        let payViewController = ChargingViewController()
        
        return payViewController
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    
    class Coordinator: NSObject {
        
        var parent: PayViewController
        
        init(_ payViewController: PayViewController) {
            parent = payViewController
        }
    }
    
}

struct OrderConfirmationView: View {
    var body: some View {
        PayViewController()
    }
}
