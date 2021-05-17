//
//  AnnounceListInRealTime.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/01.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class GetAnnounceListInRealTime: ObservableObject {
    
    
    private let db = Firestore.firestore()
    private var collection: String
    
    init(collection: String) {
        self.collection = collection
        print("coll: \(self.collection)")
        
    }
    
    var json = Data()
    var decoder = JSONDecoder()
    var dicArray: [Dictionary<String, Any>] = []
    
    
    func isValid(ann: Announce) -> Bool {
        ann.timeLimit.pastOrFuture() && ann.validity
    }
    @Published var annList: [Announce] = []
    @Published var list: [Announce] = [] {
        didSet {
            self.annList = self.list.filter({isValid(ann: $0)})
        }
    }

    func common(documents: Array<QueryDocumentSnapshot>) {
        // 初期化
        self.list = []
        self.dicArray = []
        
        for snap in documents {
            // prepare
            var dic: [String: Any] = [:]
            // only get id because id isn't exsist in document field
            dic.updateValue(snap.documentID, forKey: "id")
            dic.merge(snap.data()) {$1}
            self.dicArray.append(dic)
        }

        do {
            self.json = try JSONSerialization.data(withJSONObject: self.dicArray, options: [])
            if let JSONString = String(data: json, encoding: String.Encoding.utf8) {
               print(JSONString)
            }
        } catch {
            fatalError("Couldn't JSONSerialization...\(error)")
        }
        
        do {
            self.list = try self.decoder.decode([Announce].self, from: self.json)
        } catch {
            fatalError("Couldn't parse json as \([Announce].self):\n\(error)")
        }
    }

    func getListInRealTimeAnnounce() {
        
        /** validity filterd after */
        db.collection(collection).whereField("timeLimit", isGreaterThan: Date().dateToString()).addSnapshotListener { querySnapshot, error in
            print("\n annouce \(Date().dateToString())")
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            print("\n getListInRealTimeAnnouce() called \(self.collection)")
            self.common(documents: documents)
        }
    }
}
