//
//  MapSubAnnounceView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/26.
//

import SwiftUI

struct MapSubAnnounceView: View {
    
    @ObservedObject var announce = ShopDetail.shared.shop!.announce

    var body: some View {
        VStack {
            if let annMine = announce.annList.filter( {$0.id.suffix(28) == UserStatus.shared.uid!} ).last {
                MabSubAnnounceMyView(ann: annMine)
            } else {
                // there is no announce of mine but of other
                if let annOther = announce.annList.last {
                    MabSubAnnounceOtherView(ann: annOther)
                }
            }
        }
    }
}

struct MabSubAnnounceMyView: View {
    @ObservedObject var ann: Announce
    var body: some View {
        Text("\(ann.countDown)後にここに行くとアナウンス中")
            .announce()
            .padding(.horizontal, 30)
            .padding(.bottom, 10)
    }
}

struct MabSubAnnounceOtherView: View {
    @ObservedObject var ann: Announce
    var body: some View {
        Text("ここに\(ann.countDown)後に買い物に行く人がいます")
        .announce()
        .padding(.horizontal, 30)
        .padding(.bottom, 10)
    }
}
