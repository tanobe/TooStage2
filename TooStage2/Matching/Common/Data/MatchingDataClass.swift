//
//  MatchingClass.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/01.
//

import SwiftUI

enum MatchingRequestStatus {
    case first
    case second
    case thired
    case fourth
}

enum MatchingUndertakeStatus {
    case first
    case second
    case thired
    case fourth
}

class MatchingDataClass: ObservableObject {
    
    // MARK: - Common

    /// class
    static let shared = MatchingDataClass()
    @Published var matching = GetDocumentInRealTime<Matching>(collection: "matching")
    
    /// property
    @Published var status = MatchingRequestStatus.first
    @Published var naviActive = false
    @Published var loading = false
    @Published var cancelIsOn = false
    @Published var cancelOneSide = false
    @Published var cancelBothSides = false
    @Published var evaluateValue: Int = 3
    @Published var consultWithTooIsOn = false
    @Published var comopletedIsOn = false
    @Published var thanksIsOn = false
    
    
    
    // MARK: - Request Side Properties
    
    @Published var changeRewardIsOn = false
    @Published var lowRewardIsOn = false
    @Published var checkReceiptIsOn = false
    @Published var reciptIsOn = false
    //The followings are parts for textField of ChangeRewardModalView
    @Published var inputValue = ""
    @Published var numberIsOK = false
    
    
    
    // MARK: - Undertake Side Properties
    
    /// view
    @Published var underArrivingStoreIsOn = false
    @Published var undDeliveringIsOn = false
    @Published var lowExactAmountIsOn = false
    // The followings are parts for textField of inputExactAmount
    @Published var inputExactAmount = ""
    // The followings are parts for NaviMiniDefButtonView
    @Published var isNaviActive = false
    
    /// recipt
    @Published var isShowPhoto = false
    @Published var showWhatType = ""
    @Published var imageSet = UIImage()
    @Published var imageDeleteModal = false
    @Published var imageArrId = UUID()
    @Published var imagesPrepare = [IdentifiedUIImage]()
    @Published var waitingForUploadImage = false
    
    /// storage
    var storageSet = StorageSetRecipt()
    @Published var storageGet = FireStorageGetList()
    
}

// since the transaction is terminated
// in the order of request followed by undertake

/** req side
 *
 * (evaluatePartner have aleady done)
 *
 * send money and wait for the response
 * transferedMoney = TimeAndBool()
 * compReq = true
 *
 * self.matchingId = "" / END
 */

/** und side
 *
 * (evaluatePartner have aleady done)
 *
 * compUnd = true
 * endTime = Date().dateToString()
 *
 * set history to subcollection users/self/history ...
 * set history to subcollection users/his/history/...
 * set evaluation to subcollection users/self/evaluation...
 * set evaluation tosubcollection users/his/evaluation...
 * self.matchingId = "" / END
 */
