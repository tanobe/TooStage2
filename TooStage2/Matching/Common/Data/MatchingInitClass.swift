//
//  MatchingInitClass.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/23.
//

import SwiftUI

extension MatchingDataClass {
    
    func initAll() {
        self.naviActive = false
        self.loading = false
        self.cancelIsOn = false
        self.cancelOneSide = false
        self.cancelBothSides = false
        self.evaluateValue = 3
        self.consultWithTooIsOn = false
        self.comopletedIsOn = false
        self.thanksIsOn = false



        // MARK: - Request Side Properties

        self.changeRewardIsOn = false
        self.lowRewardIsOn = false
        self.checkReceiptIsOn = false
        self.reciptIsOn = false
        //The followings are parts for textField of ChangeRewardModalView
        self.inputValue = ""
        self.numberIsOK = false



        // MARK: - Undertake Side Properties

        /// view
        self.underArrivingStoreIsOn = false
        self.undDeliveringIsOn = false
        self.lowExactAmountIsOn = false
        // The followings are parts for textField of inputExactAmount
        self.inputExactAmount = ""
        // The followings are parts for NaviMiniDefButtonView
        self.isNaviActive = false

        /// recipt
        self.isShowPhoto = false
        self.showWhatType = ""
        self.imageSet = UIImage()
        self.imageDeleteModal = false
        self.imageArrId = UUID()
        self.imagesPrepare = [IdentifiedUIImage]()
        self.waitingForUploadImage = false
    }
}
