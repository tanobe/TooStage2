//
//  PaymentCopy.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/25.
//

import UIKit
import Stripe
import SwiftUI

class CheckoutFlag: ObservableObject {
    static let shared  = CheckoutFlag()
    @Published var canceled = false
    @Published var failed = false
}

class CheckoutWithStripe: UIViewController, STPAuthenticationContext {
    
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }

    var paymentIntentClientSecret: String?
    
    func startCheckout(totalExaAmount: Int, exaFee: Int, suid: String) {
        // Create a PaymentIntent by calling the sample server's /create-payment-intent endpoint.
        let url = URL(string: backendURL + "/stripeModule-paymentIntent")!
        
        let json: [String: Any] = [
            "totalAmount": totalExaAmount,
            "fee": exaFee,
            "suid": suid
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let clientSecret = json["clientSecret"] as? String else {
                print("\n no clientSecret")
                return
            }

            print("Created PaymentIntent")
            self?.paymentIntentClientSecret = clientSecret
            // Configure the SDK with your Stripe publishable key so that it can make requests to the Stripe API
            // For added security, our sample app gets the publishable key from the server
            (StripeAPI.defaultPublishableKey = stripePublishableKey)
        })
        task.resume()
    }
    
    func payAndSetData(card: CreditCard) {
        guard let paymentIntentClientSecret = paymentIntentClientSecret else {
            return
        }
        // Collect card details
        let param = STPCardParams()
        param.number = card.number
        param.expMonth = UInt(card.expMonth)
        param.expYear = UInt(card.expYear)
        param.cvc = card.cvc
        
        let cardParams = STPPaymentMethodCardParams(cardSourceParams: param)
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams

        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
            
            // ローディングを終了する
            MatchingDataClass.shared.loading = false
            
            switch (status) {
            case .failed:
                CheckoutFlag.shared.failed = true
                break
            case .canceled:
                CheckoutFlag.shared.canceled = true
                break
            case .succeeded:
                MatchingDataClass.shared.matching.setDocument(doc: UserData.shared.data!.matchingId) {
                    MatchingDataClass.shared.comopletedIsOn = true
                    // transfered money
                    MatchingDataClass.shared.matching.data?.reqUserData.transferedMoney = MatchingDataClass.shared.setTimeAndBool()
                    // evaluate partner (comment have not existed yet)
                    MatchingDataClass.shared.assignEvaluatePartner()
                    // complete
                    MatchingDataClass.shared.matching.data?.status.compReq = true
                }
                MatchingDataClass.shared.thanksIsOn = true
                break
            @unknown default:
                fatalError()
                break
            }
        }
    }
}
