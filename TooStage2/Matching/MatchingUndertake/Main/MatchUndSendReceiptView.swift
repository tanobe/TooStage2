//
//  MatchUnderSendReceiptView.swift
//  TooStage2
//
//  Created by 田野辺開 on 2021/04/11.
//

import SwiftUI

struct MatchUndSendReceiptView: View {
    
    @Environment(\.presentationMode) private var presentationMode

    @StateObject var shared = MatchingDataClass.shared
    @ObservedObject var matching = MatchingDataClass.shared.matching
    @ObservedObject var uploadedImage = MatchingDataClass.shared.storageGet
    
    init() {}

    var body: some View {
        VStack {
            TitleView(present: presentationMode, title: "レシートの送信")
            ScrollView {
                VStack {
                    Text("商品の確認のために、買った商品と個数、金額がはっきり見えるレシートの写真をアップロードしてください。")
                        .subTitle()
                        .padding(.horizontal)
                    
                    AnnotationRedView(text: "レシートは商品や支払額の確認に使用します。万が一、ミスやもらい忘れの場合にはチャットで連絡し、買い物の内容をテキストで送信してください。")
                        .padding(.horizontal)
                }
                    .padding(.bottom, 44)
                
                HStack(alignment: .bottom) {
                    VStack(spacing: 24) {
                        Button(action: {
                            self.shared.showWhatType = "library"
                            self.shared.isShowPhoto = true
                        },label: {
                            Image(systemName: "tray.and.arrow.up.fill")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                        })
                        Text("ファイルから選択")
                            .fontWeight(.medium)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    VStack(spacing: 22) {
                        Button(action: {
                            self.shared.showWhatType = "camera"
                            self.shared.isShowPhoto = true
                        },label: {
                            Image(systemName: "camera.circle")
                                //以下2行はfont()でサイズを調整出来ないため使用
                                .font(.system(size: 43))
                                .frame(alignment: .bottom)
                                .foregroundColor(.black)
                        })
                        Text("撮影する")
                            .fontWeight(.medium)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(width: 250)
                .padding(.bottom, 40)
                
                VStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("選択した写真")
                            .subTitle()
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 5) {
                                ForEach(self.shared.imagesPrepare) { img in
                                    Button(action: {
                                        self.shared.imageDeleteModal = true
                                        self.shared.imageArrId = img.id
                                    }, label: {
                                        Image(uiImage: img.image)
                                            .resizable()
                                            .scaledToFill()
                                            .cornerRadius(5)
                                    })
                                }
                                .frame(height: 100)
                            }
                        }
                    }
                    .padding(.bottom, 30)
                    
                    
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("アップロード済みの写真")
                                .subTitle()
                            Text("一度送信した画像は削除できません。追加のみ可能です。")
                                .caution1()
                        }
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 5) {
                                ForEach(self.uploadedImage.list) { img in
                                    img.image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(5)
                                }
                                .frame(height: 100)
                            }
                        }
                        .onAppear {
                            self.shared.storageGet.getList(url: "/matching/" + UserData.shared.data!.matchingId + "/recipt/")
                        }
                    }
                    .padding(.bottom, 30)
                    
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("購入代金の合計金額入力")
                        .subTitle()
                    HStack {
                        TextField("100", text: $shared.inputExactAmount)
                            .padding(5)
                            .font(Font.title.weight(.bold))
                            .background(Color.white)
                            .frame(width: 100)
                            .cornerRadius(10)
                            .offset(x: -5)
                            .keyboardType(.numberPad)
                            
                        Text("円")
                            .itemRes()
                            .offset(x: -10)
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            
            NaviFuncButtonView(
                text: matching.data!.undUserData.sentRecipt.done ? "アップロードして商品を届ける" : "更新",
                processing: {
                    if shared.isValidSentRecipt() {
                        
                        if let matching = matching.data {
                            self.shared.storageSet.uploadImages(list: self.shared.imagesPrepare, url: "/matching/" + matching.id + "/recipt/")
                            
                            self.matching.setDocument(doc: matching.id) {
                            
                                self.matching.data?.undUserData.bought = shared.setTimeAndBool()
                                let sentRecipt = SentRecipt(
                                    time: Date().dateToString(),
                                    done: true,
                                    exactAmount: Int(shared.inputExactAmount)!)
                                self.matching.data?.undUserData.sentRecipt = sentRecipt
                            
                            }
                            let notif: [String: Any] = [
                                "fmcToken": matching.request.fmcToken,
                                "title": "もうすく商品が届きます！",
                                "body": "レシートと金額が正しいことを確認してください。"
                            ]
                            Webhook.shared.post(url: "notification", body: notif)
                        }
                        
                        
                        
                    }
                },
                nextView: MatchUndCarryGoodsView(),
                color: shared.isValidSentRecipt() ? "color1" : "color1-1"
            )
            .disabled(!(shared.isValidSentRecipt()))
        }
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())

        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
        .sheet(isPresented: $shared.isShowPhoto) {
            if shared.showWhatType == "library" {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$shared.imageSet)
                
            } else {
                ImagePicker(sourceType: .camera, selectedImage: self.$shared.imageSet)
            }
        }
        .loading(isPresented: $shared.waitingForUploadImage)
        .modalSheet(isPresented: $shared.imageDeleteModal) {
            MiniModalTwoChoicesView(
                text: "この画像を削除しますか？",
                leftButton: FuncMiniBorderButtonView(
                    text: "もどる",
                    processing: {
                        self.shared.imageDeleteModal = false
                    }),
                rightButton: FuncMiniButtonView(
                    text: "削除",
                    processing: {
                        self.shared.imageDeleteModal = false
                        self.shared.deleteTheImageFromPrepare()
                    })
            )
        }
        .modalSheet(isPresented: $shared.lowExactAmountIsOn) {
            MiniModalOneButtonView(
                text: "購入代金を正しく入力してください",
                button: FuncMiniButtonView(
                    text: "はい",
                    processing: {
                        self.shared.lowExactAmountIsOn = false
                        self.shared.inputExactAmount = ""
                    }),
                isOn: $shared.lowExactAmountIsOn)
        }
    }
}
