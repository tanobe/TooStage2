//
//  FirestoreGet.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/01/25.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class GetDocumentInRealTime<T: Codable>: ObservableObject {
    private let db = Firestore.firestore()
    private var collection: String
    
    init(collection: String) {
        self.collection = collection
    }
    
    var json = Data()
    var decoder = JSONDecoder()
    
    @Published var data: T?
    
    func setDocument(doc: String = UserStatus.shared.uid!, _ proc: @escaping () -> Void ) {
        
        proc()
        
        do {
            try db.collection(collection).document(doc).setData(from: self.data)
            print("kokokokokokko")
        } catch {
            fatalError("Unable to add data: \(error.localizedDescription)")
        }
    }
    
    func updateDocumentForPayAccount(doc: String = UserStatus.shared.uid!, data: [String: Any]) {
        db.collection(collection).document(doc).updateData(data) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                PaymentStatus.shared.checkPaymentStatus()
                
                // the indicator is ordered to stop at here
                if PaymentStatus.shared.status == .onboardOnly {
                    LoadingTrigger.shared.isOn = false
                }
                // because need not to show Vstack{} modal view
                if PaymentStatus.shared.status == .all {
                    PaymentStatus.shared.regPayModal = false
                }
                print("Document successfully updated")
            }
        }
    }
    
    func updateDocument(doc: String = UserStatus.shared.uid!, data: [String: Any]) {
        db.collection(collection).document(doc).updateData(data) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func getDocument(doc: String) {
        db.collection(collection).document(doc).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
            return
                
            }
            guard let data = document.data() else {
                print("Document data was empty.")
            return
            }
 
            var dic: [String: Any] = [:]
            // only get id because id isn't exsist in document field
            dic.updateValue(document.documentID, forKey: "id")
            dic.merge(data) {$1}
            
            
            do {
                self.json = try JSONSerialization.data(withJSONObject: dic, options: [])
            } catch {
                fatalError("Couldn't JSONSerialization...\(error)")
            }
            
            do {
                self.data = try self.decoder.decode(T.self, from: self.json)
            } catch {
                fatalError("Couldn't parse json as \(T.self):\n\(error)")
            }
        }
    }
}

class FireStoreGetListInRealTime<T: Decodable & Equatable>: ObservableObject {
    
    
    private let db = Firestore.firestore()
    private var collection: String
    
    init(collection: String) {
        self.collection = collection
        print("coll: \(self.collection)")
        
    }
    
    var json = Data()
    var decoder = JSONDecoder()
    var dicArray: [Dictionary<String, Any>] = []    
    @Published var list: [T] = []
    
    // retrive the difference or the all ?
    // 画面遷移でstop
    func common(documents: Array<QueryDocumentSnapshot>) {
        // 初期化
        self.list = []
        self.dicArray = []
        
        for snap in documents {
            print("\n get 1")
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
            self.list = try self.decoder.decode([T].self, from: self.json)
        } catch {
            fatalError("Couldn't parse json as \([T].self):\n\(error)")
        }
    }

    func getListInRealTimeGeneral() {
        let listener = db.collection(collection)
            .addSnapshotListener { querySnapshot, error in
                
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                print("\n getListInRealTimeGeneral() called \(self.collection)")
                self.common(documents: documents)
        }
        
        func stop() {
            listener.remove()
        }
    }
    
}


class FireStoreGetList<T: Decodable>: ObservableObject {
    
    
    private let db = Firestore.firestore()
    private var collection: String
    
    init(collection: String) {
        self.collection = collection
        getList()
    }
    
    var json = Data()
    var decoder = JSONDecoder()
    var dicArray: [Dictionary<String, Any>] = []
    
    @Published var list: [T] = []
    
    func getList() {
        db.collection(collection).getDocuments { (QuerySnapshot, error) in
            guard let documents = QuerySnapshot?.documents else {
                print("No documents")
                return
            }
            
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
            } catch {
                fatalError("Couldn't JSONSerialization...\(error)")
            }

            do {
                self.list = try self.decoder.decode([T].self, from: self.json)
            } catch {
                fatalError("Couldn't parse json as \([T].self):\n\(error)")
            }
        }
    }
    
    
}


class FirestoreIsExist {

    private let db = Firestore.firestore()
    private var collection: String
    private var doc: String?

    init(collection: String, doc: String?) {
        self.collection = collection
        self.doc = doc ?? nil
    }
    
    // This is only for user authentication now: 2021/01/31
    // whether there is completed user data
    func getIsDocument() {
        db.collection(collection).document(doc!).getDocument { (document, error) in
            if let document = document, document.exists {
                 let _ = document.data().map(String.init(describing:)) ?? "nil"
                print("\n called getIs Document ")
                // User aleady have a complete set
                
                UserStatus.shared.assignTokenCompleted()
//                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.toContentView()
                
            } else {
                // User have not completed authentication yet
                UserStatus.shared.assignTokenSigned()
                return
            }
        }
    }
}
