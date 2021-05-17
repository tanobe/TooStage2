//
//  DataFieldView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/02/01.
//

import SwiftUI

struct FieldIsOkView: View {
    
    @Binding var isOK: Bool?
    var annotationDef: String?
    var annotationErr: String
    var body: some View {
        if isOK  == true {
            HStack {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(Color("color3"))
                    .font(.subheadline)
            }
        } else if isOK == false {
            HStack {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(Color("red1"))
                    .font(.subheadline)
                Text(annotationErr)
                    .foregroundColor(Color("red1"))
                    .font(.caption)
            }
        } else {
            // nil
            Text(annotationDef ?? "")
                .font(.caption)
        }
    }
}

// MARK: - TextFiled
struct UserInfoTextFieldView: View {
    
    var title: String
    var example: String
    @Binding var userInput: String
    @Binding var isOK: Bool?
    var annotationDef: String?
    var annotationErr: String
    var keyboardType: UIKeyboardType?
    

    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(spacing: 20) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                FieldIsOkView(isOK: $isOK, annotationDef: annotationDef, annotationErr: annotationErr)
            }
               
            VStack(alignment: .leading) {
                TextField(example, text: $userInput)
                    .keyboardType(keyboardType ?? .default)
                Divider()
            }
        }
        .padding(.top, 35)
        
    }
}



// MARK: - Choose gender
struct SexIconView: View {
    
    @Binding var sex: String
    @Binding var isOK: Bool?
    var selfSex: String
    var color: Color
    var defcolor: Color
    
    
    var body: some View {
        Button(action: {
            self.sex = self.selfSex
            self.isOK = true
        }, label: {
            if self.sex == self.selfSex {
                Image(systemName: "person.crop.circle")
                    .foregroundColor(color)
                    .font(.title)
            } else {
                Image(systemName: "person.crop.circle")
                    .foregroundColor(defcolor)
                    .font(.title)
            }
        })
    }
}

struct SexFieldView: View {
    
    var title: String
    @Binding var userInput: String
    @Binding var isOK: Bool?
    var annotationDef: String?
    var annotationErr: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            VStack(alignment: .leading) {
                HStack(spacing: 20) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    FieldIsOkView(isOK: $isOK, annotationDef: annotationDef, annotationErr: annotationErr)
                }
            }
            HStack(spacing: 10) {
                SexIconView(sex: $userInput, isOK: $isOK, selfSex: "male", color: .blue, defcolor: Color("male"))
                SexIconView(sex: $userInput, isOK: $isOK, selfSex: "female", color: .pink, defcolor: Color("female"))
            }
        }
        .padding(.top, 35)
    }
}



// MARK: - Payment Field
struct PayoutTextFieldView: View {
    
    var title: String
    var example: String
    @Binding var userInput: String
    @Binding var isOK: Bool?
    var annotationDef: String?
    var keyboardType: UIKeyboardType?
    

    var body: some View {
        
        VStack {
            VStack(spacing: 5) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
               
            VStack(alignment: .leading) {
                TextField(example, text: $userInput)
                    .keyboardType(keyboardType ?? .default)
                    .font(Font.title.weight(.bold))
                    .multilineTextAlignment(.center)
                    
                Divider()
                    .foregroundColor(.black)
            }
            .frame(width: 100)
        }
        .padding(.top, 35)
        
    }
}





// MARK: - Date field
struct DatePickerModalView: View {
    @Binding var date: Date
    @Binding var isOn: Bool
    
    var body: some View {
        VStack {
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
            
            FuncMiniButtonView(text: "完了", processing: {
                self.isOn = false
            })
            .frame(width: 200)
        }
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct UserInfoDateFieldView: View {
    
    var title: String
    @Binding var userInput: Date
    @Binding var isOK: Bool?
    @Binding var showModal: Bool
    var annotationDef: String?
    var annotationErr: String
    

    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(spacing: 20) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    
                FieldIsOkView(isOK: $isOK, annotationDef: annotationDef, annotationErr: annotationErr)
            }
            .padding(.bottom, 5)
            
            VStack(alignment: .leading, spacing: 10) {
                if isOK != nil {
                    Text(userInput.dateToStringJa())
                } else {
                    Text("2020年 2月 2日")
                        .foregroundColor(Color("gray5"))
                }
                
                Divider()
            }
            .frame(maxWidth: .infinity)
            .onTapGesture {
                self.showModal = true
            }
        }
        .padding(.top, 35)
        
    }
}
