//
//  CheckoutViewController.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/02/04.
//

import UIKit
import Stripe
import SwiftUI

/**
 * This example collects card payments, implementing the guide here: https://stripe.com/docs/payments/accept-a-payment#ios
 * To run this app, follow the steps here https://github.com/stripe-samples/accept-a-card-payment#how-to-run-locally
 */

// 初回登録画面
class ChargingViewController: UIViewController {
    
    let buttonTitle: String = "登録"

    lazy var cardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        cardTextField.postalCodeEntryEnabled = false
        return cardTextField
    }()
    
    lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "color1")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.setTitle(buttonTitle, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 5.0, bottom: 12, right: 0.0)
        button.addTarget(self, action: #selector(checkCardValidity), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [cardTextField, payButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalToSystemSpacingAfter: view.leftAnchor, multiplier: 2),
            view.rightAnchor.constraint(equalToSystemSpacingAfter: stackView.rightAnchor, multiplier: 2),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
        ])
    }
    
    func displayAlert(title: String, message: String, restartDemo: Bool = false) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "はい", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc
    func checkCardValidity() {
        let params = STPCardParams()
        let card = cardTextField.cardParams
        
        guard let number = card.number,
              let expMonth = card.expMonth,
              let expYear = card.expYear,
              let cvc = card.cvc
        else {
            displayAlert(title: "エラー", message: "カード情報に不備があります。")
            return
        }
        
        params.number = number
        params.expMonth = expMonth as! UInt
        params.expYear = expYear as! UInt
        params.cvc = cvc
        
        if STPCardValidator.validationState(forCard: params) == .valid {
            let card = CreditCard(
                number: params.number!,
                expMonth: Int(params.expMonth),
                expYear: Int(params.expYear),
                cvc: params.cvc!,
                last4: params.last4()!)
            
            let data: [String: Any] = [
                "card": card.data,
                "cardIs": true
            ]
            // update userData to firestore then addListener get it in real time
            UserData.shared.updateDocumentForPayAccount(data: data)
            // check userData cardIs updated and assign to @Published then the view will be reloaded.
            PaymentStatus.shared.checkPaymentStatus()
            // show alert in modalSheet
        } else {
            // show try again
            displayAlert(title: "エラー", message: "カード情報に不備があります。")
        }
    }
}

extension ChargingViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
