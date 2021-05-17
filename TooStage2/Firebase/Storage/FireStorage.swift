//
//  FireStorage.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/02.
//

import SwiftUI
import FirebaseStorage

struct IdentifiedImage: Identifiable, Equatable {
    var id = UUID()
    var image: Image
}

struct IdentifiedUIImage: Identifiable, Equatable {
    var id = UUID()
    var image: UIImage
}

class FireStorageGetEsc {
    
    static let shared = FireStorageGetEsc()

    let storage = Storage.storage()
    let queue = DispatchQueue.global(qos: .userInteractive)
    
    init(){
        print("\n load image ")
    }
    
    func get(url: String, _ completion: @escaping (Image) -> Void){
        let ref = storage.reference(forURL: storageURL + url)
        queue.async {
            ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    print("\n get ERROR: \(String(describing: error))")
                    return
                }
                let uiImage = UIImage(data: data!) ?? (UIImage(named: "noImage")!)
                let image = Image(uiImage: uiImage)
                completion(image)
                print(url)
            }
        }
    }
}


class FireStorageGetList: ObservableObject {
    let storage = Storage.storage()
//    let semaphore = DispatchSemaphore(value: 0)
//    let queue = DispatchQueue.global(qos: .userInteractive)
    
    var image = Image("noImage")
    @Published var list = [IdentifiedImage]()
    
    init(){}
    
    func getForList(ref: StorageReference) {
        self.list = []
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print("\n get ERROR: \(String(describing: error))")
                return
            }
            let uiImage = UIImage(data: data!) ?? (UIImage(named: "noImage")!)
            self.image = Image(uiImage: uiImage)
            let imageSt = IdentifiedImage(image: self.image)
            if self.list.filter({$0.image == self.image}).isEmpty {
                self.list.append(imageSt)
            }
        }
    }
    
    // this semaphore is valid
    func getList(url: String) {
        // 直列 -> 並列処理

        let ref = storage.reference(forURL: storageURL + url)
//        var count = 0
        ref.listAll { result, error in
            if error != nil {
                print("\n get list ERROR: \(String(describing: error))")
                return
            }
//            self.queue.async {
                for item in result.items {
                    self.getForList(ref: item)
//                    count += 1
//                    print("\n count: \(count)")
//                    if count == result.items.count {
//                        self.semaphore.signal()
//                        print("\nsignaled")
//                    }
                }
//                self.semaphore.wait()
//            }
        }
    }
    
}


class FireStorageGet: ObservableObject {

    let storage = Storage.storage()
    let semaphore = DispatchSemaphore(value: 0)
    
    /**
     * "noImage" is a default image. this will be displayed two situations.
     * 1. the expected image couldn't get by some error
     * 2. the expected image haven't got yet
     */
    
    @Published var image = Image("noImage")
    /**
     * the property wrapper receive this must be not @ObservedObject but @StateObject
     * because @ObservedObject will be reloaded by other property wrappers changes
     */
    
    init(url: String){
        get(url: url)
        // print("\n got image")
    }

    func get(url: String) {
        let ref = storage.reference(forURL: storageURL + url)
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print("\n get ERROR: \(String(describing: error))")
                return
            }
            let uiImage = UIImage(data: data!) ?? (UIImage(named: "noImage")!)
            self.image = Image(uiImage: uiImage)
        }
    }
    
    deinit {
        print("\n deinit")
    }
}


class StorageSetRecipt: ObservableObject {
    
    let storage = Storage.storage()
    var image: IdentifiedUIImage?
    var imageList: [IdentifiedUIImage]?
    
    func uploadAnImage(url: String, name: String, image: IdentifiedUIImage) {
        guard let imageData = image.image.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        let storageRef = storage.reference()
        let ref = storageRef.child(url + name + ".jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        ref.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                print("ERROR STORAGE: \(error)")
            }

            if MatchingDataClass.shared.imagesPrepare != [] {
                MatchingDataClass.shared.imagesPrepare = []
            }
        }
    }
    
    func uploadImages(list: [IdentifiedUIImage], url: String) {
        for i in list {
            self.uploadAnImage(url: url, name: i.id.uuidString, image: i)
        }
        
    }
}

