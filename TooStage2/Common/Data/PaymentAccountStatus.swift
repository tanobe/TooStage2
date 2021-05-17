//
//  PaymentAccountStatus.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/27.
//

import SwiftUI


class PaymentStatus: ObservableObject {
    
    static let shared = PaymentStatus()
    
    @Published var status: PayAccStatus = .non
    @Published var regPayModal = false
    
    enum PayAccStatus {
        case non, onboardOnly, all
    }
    
    /**
     * regAccは「依頼する」ボタンによって制御
     * statusはcheckPaymentStatus()によって制御
     * 制御結果（statusへの代入結果）はLookingCartViewによって監視されているのでviewは自動で変化する
     * checkPaymentStatus()はUserData.sharedの値に依存するので、
     * UserData.shared.data?.onboardIs　と　UserData.shared.data?.cartIs の値を変更するために
     * 任意のタイミングでfirestoreのuserデータを管理
     */
    
    func checkPaymentStatus() {
        
        guard let onboardIs = UserData.shared.data?.onboardIs,
              let cardIs = UserData.shared.data?.cardIs else {
            status = .non
            return
        }
        
        switch (onboardIs, cardIs) {
        case (true, true):
            status = .all
        case (true, false):
            status = .onboardOnly
        case (false, false):
            status = .non
        default:
            status = .non
        }
        
    }
    
}
    
