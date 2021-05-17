//
//  FirestoreNotInUse.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/28.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreGetCollectionGroup<T: Decodable>: ObservableObject {
    private let db = Firestore.firestore()
    private var collection: String

    init(collection: String) {
        self.collection = collection
        self.getCollectionGroup()
    }
    
    var json = Data()
    let decoder = JSONDecoder()
    var dicArray: [Dictionary<String, Any>] = []
    
    // get multiple data like shop item List
    @Published var list: [T] = []
    
    // get all of document belong to 'collection'
    func getCollectionGroup() {
        db.collectionGroup(collection).getDocuments { (QuerySnapshot, error) in
            guard let documents = QuerySnapshot?.documents else {
                print("No documents")
                return
            }
            
            print("\n OMG OMG OMG ")
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


class FirestoreGetItemList<T: Decodable>: ObservableObject {

    private let db = Firestore.firestore()
    private var collection: String

    init(collection: String) {
        self.collection = collection
    }
    
    var json = Data()
    let decoder = JSONDecoder()
    var dicArray: [Dictionary<String, Any>] = []
    
    
    // get multiple data like shop, item List
    @Published var list: [T] = []
    
    @Published var category: String = "すべて"
    func getDataList() {
        
        db.collection(collection).getDocuments { (QuerySnapshot, error) in
            guard let documents = QuerySnapshot?.documents else {
                print("No documents")
                return
            }

            print("\n OMG OMG")
            for snap in documents {
                print("\nfor in firestore get list")
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

            // print(self.list)

        }
    }
}

class FirestoreGetDocument<T: Decodable>: ObservableObject {

    private let db = Firestore.firestore()
    private var collection: String
    private var doc: String?
    @Published var data: T?

    init(collection: String, doc: String?) {
        self.collection = collection
        self.doc = doc ?? nil
        self.getData()
    }
    
    var json = Data()
    let decoder = JSONDecoder()
    
    // get single data like user info
    func getData() {
        print("\n start getData")
        // Forcing synchronous communication

        db.collection(collection).document(doc!).getDocument { (documentSnapshot, error) in
            
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
            
            print(self.data ?? "\n data: unknown")
        }
        
    }
}

