//
//  StrageView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/01.
//

import SwiftUI
import FirebaseStorage

/**
Reference's path is: "images/space.jpg"
This is analogous to a file path on disk
    - spaceRef.fullPath

Reference's name is the last segment of the full path: "space.jpg"
This is analogous to the file name
    - spaceRef.name

Reference's bucket is the name of the storage bucket where files are stored
    - spaceRef.bucket
 */

struct SampleGetImagesView: View {
    
    @ObservedObject var images = FireStorageGetList()
    
    init() {
        images.getList(url: "/shops/shop1/category/commodity")
    }
    
    var body: some View {
        List {
            ForEach(images.list) { list in
                list.image
                    .resizable()
                    .frame(width: 200, height: 200)
            }
        }
        Button(action: {
            //Load()
        }, label: {
            Text("もっと見る")
        })
    }
}

