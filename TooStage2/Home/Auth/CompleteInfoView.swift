//
//  CompleteView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/01/28.
//

import SwiftUI



struct CompleteInfoView: View {
    
    @StateObject var info = CompleteInfo()
    @ObservedObject var keyboard = KeyboardObserver()
    
    private func registerWithFirestore() {
        // resist user data with firestore
        
        // prepare birthday data
        let stringDate = info.date.dateToStringYMD()
        let arr: [String] = stringDate.components(separatedBy: "/")
        let fmcToken = UserStatus.shared.fmcToken ?? ""
        let birthDay = BirthDay(year: arr[0], month: arr[1], day: arr[2])
        
        let user = UserInfo(email: info.email, familyName: info.familyName, givenName: info.givenName, sex: info.sex, postalCode: Int(info.zipCode)!, address1: info.address1, address2: info.address2, roomNumber: info.roomNumber, birthDay: birthDay, fmcToken: fmcToken)
        
        
        let firestoreSet = FirestoreSet(collection: "users")
        firestoreSet.set(data: user, document: UserStatus.shared.uid!)
    }
    
    func complete() {
        registerWithFirestore()
        UserStatus.shared.assignTokenCompleted()
    }
    
    var body: some View {
        VStack {
            CompleteInfoHeaderView()
            ScrollView {
                VStack {
                    
                    VStack(alignment: .leading){
                        HStack(alignment: .top) {
                            UserInfoTextFieldView(title: "性", example: "東京", userInput: $info.familyName, isOK: $info.familyNameIsOK, annotationErr: "空欄です")
                            UserInfoTextFieldView(title: "名", example: "花子", userInput: $info.givenName, isOK: $info.givenNameIsOK, annotationErr: "空欄です")
                            SexFieldView(title: "性別", userInput: $info.sex, isOK: $info.sexIsOK, annotationErr: "選択してください")
                        }
                        Text("氏名・性別は政府発行の身分証明書と同じにしてください。")
                            .font(.caption2)
                            .padding(.top, 5)
                            .foregroundColor(.gray)
                    }
                    UserInfoTextFieldView(title: "メール　", example: "too@gmail.com", userInput: $info.email, isOK: $info.emailIsOK, annotationErr: "error.....", keyboardType: .emailAddress)
                        .disabled(true)

                
                    HStack {
                        // new
                        UserInfoDateFieldView(title: "生年月日", userInput: $info.date, isOK: $info.dateIsOK, showModal: $info.datePickerModal, annotationErr: "18歳未満の方は利用できません")
                        
                    }
                    UserInfoTextFieldView(title: "郵便番号", example: "0000000", userInput: $info.zipCode, isOK: $info.zipCodeIsOK, annotationErr: "対象外の地域です", keyboardType: .numberPad)
                    
                    HStack(alignment: .bottom) {
                        UserInfoTextFieldView(title: "住所１　", example: "自動入力", userInput: $info.address1, isOK: $info.address1IsOK, annotationErr: "空欄です")
                            .disabled(true)
                    }
                    UserInfoTextFieldView(title: "住所２　", example: "番地-号　例) 1231-1", userInput: $info.address2, isOK: $info.address2IsOK, annotationErr: "空欄です")
                    
                    UserInfoTextFieldView(title: "部屋番号", example: "101", userInput: $info.roomNumber, isOK: $info.roomNumberIsOK, annotationErr: "数字で入力してください", keyboardType: .numberPad)

                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            FuncButtonView(text: "登録する", processing: complete, color: info.isAllOK() ? "color1" : "color1-1")
                .disabled(!info.isAllOK())
                .padding(.bottom, 30)
        }
        .animation(.easeInOut)
        .onAppear(perform: {
              self.keyboard.addObserver()
            }).onDisappear(perform: {
              self.keyboard.removeObserver()
            }).padding(.bottom,
                       self.keyboard.keyboardHeight)
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
        .modalSheet(isPresented: $info.datePickerModal, backTapDismiss: true) {
            DatePickerModalView(date: $info.date, isOn: $info.datePickerModal)
        }
        .background(Color.white.ignoresSafeArea())
    }
}

struct AutoInputButton: View {
    
    var autoInputFunc: () -> Void
    @Binding var isOK: Bool?
    
    var body: some View {
        Button(
            action: {
                autoInputFunc()
        },
            label: {
            Image(systemName: "pencil")
                .font(Font.title2.weight(.bold))
                .foregroundColor(self.isOK ?? false ? Color("color3") : .gray)
        })
            .frame(width: 50, height: 50, alignment: .center)
            .background(Color.white)
            .cornerRadius(10)
            .shadow1(radius: 5)
            .disabled(!(self.isOK ?? false))
    }
}

struct CompleteInfoHeaderView: View {
    var body: some View {

        HStack {
            Button {
                UserStatus.shared.assignTokenNil()
            } label: {
                Image(systemName: "chevron.left")
                    .font(Font.title2.weight(.bold))
                    .foregroundColor(Color("color1"))

            }
            Spacer()
            
            Text("登録を完了する")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color("color1"))
            
            Spacer()
            Text("　")
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
}
