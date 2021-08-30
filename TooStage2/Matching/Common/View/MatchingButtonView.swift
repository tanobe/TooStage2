//
//  MatchingButtonView.swift
//  TooStage2
//
//  
//

import SwiftUI

struct MiniModalTwoChoicesMatchingView<LBV: ButtonProtocol, RBV: ButtonProtocol>: View {
    /**
     * LBV means Left Button View
     * RBV means Right Button View
     * That button could have function, navigation, or warp
     */
    var text: String
    var subText: String? = nil
    var annotation: String? = nil
    var leftButton: LBV
    var rightButton: RBV
    
    var body: some View {

        VStack(alignment: .center) {
            VStack(alignment: .center) {
                Text(text)
                    .fontWeight(.bold)
                    .font(.title3)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
                        
            VStack(alignment: .center) {
                if subText != nil {
                    Text(subText!)
                        .fontWeight(.medium)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
            }
            .frame(maxWidth: .infinity)
            if annotation != nil {
                HStack (alignment: .top) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.callout)
                        .foregroundColor(Color("red1"))
                        .frame(width: 20)
                    Text(annotation!)
                        .fontWeight(.medium)
                        .font(.caption)
                        .foregroundColor(Color("red1"))
                }
                .padding(.top, 5)
                .frame(maxWidth: .infinity)
            }
            
            HStack {
                leftButton
                rightButton
            }
            .padding(.top, 20)
                
        }
        .padding(30)
        .background(Color(.white))
        .frame(width: 300)
        .cornerRadius(10)
            
    }
}


//MARK: - MatchReqCancelButton
struct MatchCancelButton: View {
    @StateObject var shared = MatchingDataClass.shared
    @StateObject var matching = MatchingDataClass.shared.matching

    var body: some View {
        VStack {
            FuncMiniBorderButtonView(
                text: "取引をキャンセル",
                processing: {
                    self.shared.cancelIsOn = true
            })
            .padding(.horizontal)
            .padding(.bottom, 35)
        }
    }
}

struct ConsultWithTooManagementButtonView: View {
    @StateObject var shared = MatchingDataClass.shared
    var body: some View {
        FuncMiniBorderButtonView(
            text: "運営へ相談",
            processing: {
                self.shared.consultWithTooIsOn = true
            })
            .padding(.horizontal)
            .padding(.bottom, 35)
    }
}
