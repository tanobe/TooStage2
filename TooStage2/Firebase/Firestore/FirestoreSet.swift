//
//  FirestoreSet.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/01/25.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class FirestoreSet: ObservableObject {
    
    private var ref: DocumentReference? = nil
    private let db = Firestore.firestore()
    private var collection: String
    
    init(collection: String) {
        self.collection = collection
    }
    
    // set function with generics
    func set<T: Encodable>(data: T, document: String) {
        do {
            _ = try db.collection(collection).document(document).setData(from: data)
        } catch {
            fatalError("Unable to add data: \(error.localizedDescription)")
        }
    }
    
    func set<T: Encodable>(data: T) {
        do {
            _ = try db.collection(collection).document().setData(from: data)
        } catch {
            fatalError("Unable to add data: \(error.localizedDescription)")
        }
    }
}
