//
//  FirestoreUpdate.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/02/25.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreUpdate: ObservableObject {
    
    private var ref: DocumentReference? = nil
    private let db = Firestore.firestore()
    private var collection: String
    
    init(collection: String) {
        self.collection = collection
    }
    
    func update(document: String, data: [String: Any]) {
        db.collection(collection).document(document).updateData(data) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
