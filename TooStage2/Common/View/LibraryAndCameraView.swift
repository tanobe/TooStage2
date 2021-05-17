//
//  TextView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/04/18.
//

import UIKit
import SwiftUI


struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedImage: UIImage
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
                let identifiedImage = IdentifiedUIImage(image: parent.selectedImage)
                MatchingDataClass.shared.imagesPrepare.append(identifiedImage)
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct TextView: View {
    @State private var isShowLibrary = false
    @State private var isShowCamera = false
    @State private var imageLibrary = UIImage()
    @State private var imageCamera = UIImage()
    
    var body: some View {
        VStack {
 
//            Image(uiImage: self.image)
//                .resizable()
//                .scaledToFill()
//                .frame(minWidth: 0, maxWidth: .infinity)
//                .edgesIgnoringSafeArea(.all)
 
            Button(action: {
                self.isShowLibrary = true
            }) {
                HStack {
                    Image(systemName: "photo")
                        .font(.system(size: 20))
 
                    Text("Photo library")
                        .font(.headline)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal)
            }
            .padding(.bottom)
            
            Button(action: {
                self.isShowCamera = true
            }) {
                HStack {
                    Image(systemName: "camera")
                        .font(.system(size: 20))
 
                    Text("Photo library")
                        .font(.headline)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .sheet(isPresented: $isShowLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$imageLibrary)
        }
        .sheet(isPresented: $isShowCamera) {
            ImagePicker(sourceType: .camera, selectedImage: self.$imageCamera)
        }
    }
    
}
