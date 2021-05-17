//
//  RequestListInRealTime.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/01.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class GetRequestListInRealTime: ObservableObject {
    
    
    private let db = Firestore.firestore()
    private var collection: String
    
    init(collection: String) {
        self.collection = collection
        print("coll: \(self.collection)")
        
    }
    
    var json = Data()
    var decoder = JSONDecoder()
    var dicArray: [Dictionary<String, Any>] = []
    
    
    func isValid(req: Request) -> Bool {
        req.regTime.stringToDate().advanceTheTimeHH(1).dateToString().pastOrFuture() && !req.matched && req.validity && !req.timeOut
    }
    
    @Published var reqList: [Request] = []
    @Published var list: [Request] = [] {
        didSet {
            guard let sex = UserData.shared.data?.sex else {
                return
            }
            self.reqList = self.list.filter({isValid(req: $0) && $0.sex == sex})
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
            self.list = try self.decoder.decode([Request].self, from: self.json)
        } catch {
            fatalError("Couldn't parse json as \([Request].self):\n\(error)")
        }
    }

    func getListInRealTimeRequest() {
        
        /** validity and matched filterd after */
        let listener = db.collection(collection).whereField("regTime", isGreaterThan: Date().advanceTheTimeHH(-1).dateToString()).addSnapshotListener { querySnapshot, error in

            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.common(documents: documents)
        }
        
        func stop() {
            listener.remove()
        }
        
    }
}
