//
//  MatchingFuncClass.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/14.
//

import SwiftUI

// MARK: - Func For Common
extension MatchingDataClass {
    
    func setTimeAndBool() -> TimeAndBool {
        let now = Date().dateToString()
        let timeAndBool = TimeAndBool(time: now, done: true)
        return timeAndBool
    }
    
    func side() -> String {
        let reqUserId = matching.data?.id.prefix(28) ?? ""
        if reqUserId == UserStatus.shared.uid! {
            return "req"
        } else {
            return "und"
        }
    }
    
    func didReadAll() {
        if side() == "req" {
            if self.matching.data?.messages.filter({$0.readReq == false}).count != 0 {
                self.matching.setDocument(doc: self.matching.data!.id) {
                    for i in 0..<self.matching.data!.messages.count {
                        self.matching.data!.messages[i].readReq = true
                    }
                }
            }
        } else {
            if self.matching.data?.messages.filter({$0.readUnd == false}).count != 0 {
                self.matching.setDocument(doc: self.matching.data!.id) {
                    for i in 0..<self.matching.data!.messages.count {
                        self.matching.data!.messages[i].readUnd = true
                    }
                }
            }
        }
    }
    
    
    func cancelIs0or1() -> Bool {
        if (matching.data?.status.cancelReq ?? false) || (matching.data?.status.cancelUnd ?? false) {
            return true
        }
        return false
    }
    
    func cancel() {
        if cancelIs0or1() {
            // 既に片方がキャンセル申請している場合
            matching.setDocument(doc: UserData.shared.data!.matchingId) {
                self.matching.data?.status.cancelReq = true
                self.matching.data?.status.cancelUnd = true
                self.cancelBothSides = true
            }
        } else {
            // 片方が初めてキャンセル申請した
            matching.setDocument(doc: UserData.shared.data!.matchingId) {
                if self.side() == "req" {
                    self.matching.data?.status.cancelReq = true
                } else {
                    self.matching.data?.status.cancelUnd = true
                }
                self.cancelOneSide = true
            }
        }
    }
    
    func assignEvaluatePartner() {
        let now = Date().dateToString()
        let evaluateData = Evaluate(
            time: now,
            done: true,
            value: evaluateValue,
            comment: "")
        
        if self.side() == "req" {
            self.matching.data?.reqUserData.evaluatePartner = evaluateData
        } else {
            self.matching.data?.undUserData.evaluatePartner = evaluateData
        }
    }
}


// MARK: - Func For Request
extension MatchingDataClass {
    
    func judgeReqStatus() -> MatchingRequestStatus {
        guard let undStatus = self.matching.data?.undUserData else {
            return MatchingRequestStatus.first
        }
        guard let reqStatus = self.matching.data?.reqUserData else {
            return MatchingRequestStatus.first
        }
        
        let arrivedShop = undStatus.arrivedShop.done
        let bought = undStatus.bought.done
        let sentRecipt = undStatus.sentRecipt.done
        let deliveried = undStatus.deliveried.done
        let confirm = reqStatus.confirmedItemsAndFee.done
        
        switch (arrivedShop, bought, sentRecipt, deliveried, confirm) {
        case (false, false, false, false, false):
            return MatchingRequestStatus.first
        case (true, false, false, false, false):
            return MatchingRequestStatus.second
        case (true, true, false, false, false):
            return MatchingRequestStatus.second
        case (true, true, true, false, false):
            return MatchingRequestStatus.thired
        case (true, true, true, true, false):
            return MatchingRequestStatus.fourth
        case (true, true, true, true, true):
            return MatchingRequestStatus.fourth
        default:
            return MatchingRequestStatus.first
        }
    }
    
    func isValidInputReward() -> Bool {
        
        guard let reward = self.matching.data?.request.reward else {

            return false
        }
        guard let inputReward = Int(inputValue) else {
            return false
        }
        
        if (0 > inputReward) {
            self.lowRewardIsOn = true
            return false
        }
        
        if (reward > inputReward) {
            self.lowRewardIsOn = true
            return false
        }
        
        return true
    }
    
    func isValidInputRewardCaseByLow() -> Bool {
        
        guard let _ = self.matching.data?.request.reward else {
            return false
        }
        
        guard let inputReward = Int(inputValue) else {
            return false
        }
        
        if (0 > inputReward) {
            self.lowRewardIsOn = true
            return false
        }
        
        return true
    }
}


// MARK: - Func For Undertake
extension MatchingDataClass {
    
    func judgeUndStatus() -> MatchingUndertakeStatus {
        guard let undStatus = self.matching.data?.undUserData else {
            return MatchingUndertakeStatus.first
        }
        guard let reqStatus = self.matching.data?.reqUserData else {
            return MatchingUndertakeStatus.first
        }
        let arrivedShop = undStatus.arrivedShop.done
        let bought = undStatus.bought.done
        let sentRecipt = undStatus.sentRecipt.done
        let deliveried = undStatus.deliveried.done
        let transferedMoney = reqStatus.transferedMoney.done
        let reqEvaluate = reqStatus.evaluatePartner.done
        switch (arrivedShop, bought, sentRecipt, deliveried, transferedMoney, reqEvaluate) {
        case (false, false, false, false, false, false):
            return MatchingUndertakeStatus.first
        case (true, false, false, false, false, false):
            return MatchingUndertakeStatus.second
        case (true, true, false, false, false, false):
            return MatchingUndertakeStatus.second
        case (true, true, true, false, false, false):
            return MatchingUndertakeStatus.second
        case (true, true, true, true, false, false):
            return MatchingUndertakeStatus.thired
        case (true, true, true, true, true, false):
            return MatchingUndertakeStatus.thired
        case (true, true, true, true, true, true):
            return MatchingUndertakeStatus.fourth
        default:
            return MatchingUndertakeStatus.first
        }
    }
    
    func isValidInputExactAmountByLow() -> Bool {
        guard let _ = self.matching.data?.undUserData.sentRecipt.exactAmount else {
            return false
        }
        guard let ExactAmount = Int(inputExactAmount) else {
            return false
        }
        if (0 > ExactAmount) {
            self.lowExactAmountIsOn = true
            return false
        }
        return true
    }
    
    func deleteTheImageFromPrepare() {
        imagesPrepare = imagesPrepare.filter({!($0.id == imageArrId)})
    }
    
    func isValidSentRecipt() -> Bool {
        isValidInputExactAmountByLow() && (imagesPrepare.count != 0 || self.storageGet.list.count != 0)
    }

}
