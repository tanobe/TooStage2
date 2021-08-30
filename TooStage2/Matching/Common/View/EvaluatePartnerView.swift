//
//  EvaluatePartnerView.swift
//  TooStage2
//
//  
//

import SwiftUI

//MARK: - MatchingEvaluateView
struct MatchingEvaluateView: View {
    @ObservedObject var matching = MatchingDataClass.shared.matching
    @ObservedObject var shared = MatchingDataClass.shared
    
    let evaluate = ["悪い", "", "普通", "", "良い"]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("評価")
                .subTitle()
                .padding(.bottom)
            
            HStack(alignment: .top, spacing: 24) {
                Spacer()
                ForEach(0..<5) { i in
                    MatchEvaluateStarButtonView(evaluateText: evaluate[i], evaluateValue: i + 1)
                }
                Spacer()
            }
        }
        .padding()
    }
}
//MARK: - MatchEvaluateStarButtonView
struct MatchEvaluateStarButtonView: View {
    @ObservedObject var matching = MatchingDataClass.shared.matching
    @StateObject var shared = MatchingDataClass.shared
    
    var evaluateText: String
    var evaluateValue: Int
    
    var body: some View {
        Button(action: {
            
            self.shared.evaluateValue = evaluateValue
            
        }, label: {
            VStack(spacing: 4) {
                if !(evaluateValue <= self.shared.evaluateValue) {
                    Image(systemName: "star")
                        .font(.title)
                        .foregroundColor(Color("color3"))
                } else {
                    Image(systemName: "star.fill")
                        .font(.title)
                        .foregroundColor(Color("yellow1"))
                }
                Text(evaluateText)
                    .foregroundColor(.black)
                    .fontWeight(.medium)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
        })
    }
}
