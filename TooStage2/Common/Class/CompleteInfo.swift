//
//  CompleteInfo.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/02/01.
//

import SwiftUI
import CoreLocation

class CompleteInfo: ObservableObject {
    
    init(){}
    
    func isAllOK() -> Bool{
        if  (emailIsOK ?? false) &&
            (familyNameIsOK ?? false) &&
            (givenNameIsOK ?? false) &&
            (sexIsOK ?? false) &&
            (dateIsOK ?? false) &&
            (zipCodeIsOK ?? false) &&
            (address1IsOK ?? false) &&
            (address2IsOK ?? false) &&
            (roomNumberIsOK ?? false) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - function to check the truth value of an input value
    func assignBool<T>(text: T, validFunc: (T) -> Bool) -> Bool {
        var bool: Bool = false
        if validFunc(text) {
            bool = true
        } else {
            bool = false
        }
        return bool
    }

    // MARK: - email textField (email must be obtained)
    @Published var emailIsOK: Bool? = true
    @Published var email: String = UserStatus.shared.email ?? "" {
        didSet {
            emailIsOK = assignBool(text: email, validFunc: isValidEmail(_:))
        }
    }
    func isValidEmail(_ string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: string)
        return result
    }
    
    // MARK: - familyName textField
    @Published var familyNameIsOK: Bool? = nil
    @Published var familyName: String = "" {
        didSet {
            familyNameIsOK = assignBool(text: familyName, validFunc: isValidFamilyName(_:))
        }
    }
    func isValidFamilyName(_ string: String) -> Bool {
        if familyName != "" {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - givenName textField
    @Published var givenNameIsOK: Bool? = nil
    @Published var givenName: String = "" {
        didSet {
            givenNameIsOK = assignBool(text: givenName, validFunc: isValidGivenName(_:))
        }
    }
    func isValidGivenName(_ string: String) -> Bool {
        if givenName != "" {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - sex tapField
    @Published var sexIsOK: Bool? = nil
    @Published var sex: String = "" {
        didSet {
            sexIsOK = assignBool(text: sex, validFunc: isValidSex(_:))
        }
    }
    func isValidSex(_ string: String) -> Bool {
        if sex != "" {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - zipCode textField
    @Published var zipCodeIsOK: Bool? = nil
    @Published var zipCode: String = "" {
        didSet {
            zipCodeIsOK = assignBool(text: zipCode, validFunc: isValidZipCode(_:))
        }
    }
    func isValidZipCode(_ string: String) -> Bool {
        // 1111111 and 2222222 are test code. it shoud be changed.
        if zipCode == "1930845" {
            // auto input func 
            CLGeocoder().convertAddress(from: self.zipCode) { (address, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let ad = address,
                      let area1 = ad.administrativeArea,
                      let area2 = ad.locality,
                      let area3 = ad.subLocality else {
                    return
                }
                let address1 = area1 + area2 + area3
                self.address1 = address1
            }
            return true
        } else {
            address1 = ""
            return false
        }
    }
    
    func autoInput() {
        CLGeocoder().convertAddress(from: self.zipCode) { (address, error) in
            if let error = error {
                print(error)
                return
            }
            guard let ad = address,
                  let area1 = ad.administrativeArea,
                  let area2 = ad.locality,
                  let area3 = ad.subLocality else {
                return
            }
            let address1 = area1 + area2 + area3
            self.address1 = address1
        }
    }

    
    // MARK: - address1 textField
    @Published var address1IsOK: Bool? = nil
    @Published var address1: String = "" {
        didSet {
            address1IsOK = assignBool(text: address1, validFunc: isValidAddress1(_:))
        }
    }
    func isValidAddress1(_ string: String) -> Bool {
        if address1 != "" {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - address2 textField
    @Published var address2IsOK: Bool? = nil
    @Published var address2: String = "" {
        didSet {
            address2IsOK = assignBool(text: address2, validFunc: isValidAddress2(_:))
        }
    }
    func isValidAddress2(_ string: String) -> Bool {
        if address2 != "" {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - roomNumber textField
    @Published var roomNumberIsOK: Bool? = nil
    @Published var roomNumber: String = "" {
        didSet {
            roomNumberIsOK = assignBool(text: roomNumber, validFunc: isValidNumber(_:))
        }
    }
    // this is general numerical check
    func isValidNumber(_ string: String) -> Bool {
        if roomNumber.isAlphanumeric() {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - date
    // not using isBool func
    @Published var datePickerModal = false
    @Published var dateIsOK: Bool? = nil
    @Published var date: Date = "2000/02/02 22:22:22".stringToDate() {
        didSet {
            dateIsOK = isValidDate(date)
        }
    }
    
    func birthStringToDate (_ birthDay: BirthDay) -> Date {
        let day = (birthDay.year + "/" + birthDay.month + "/" + birthDay.day + " " + "00:00:00").stringToDate()
        return day
    }
    
    func isValidDate(_ date: Date?) -> Bool? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormater.string(from: date!)
        let birthdayDate = dateFormater.date(from: dateString)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        if age! < 18 {
            return false
        }
        return true
    }
    
    // MARK: - password
    @Published var passIsOK: Bool? = nil
    @Published var pass: String = "" {
        didSet {
            passIsOK = assignBool(text: pass, validFunc: isValidPass(_:))
        }
    }
    func isValidPass(_ string: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: string)
    }
    
//    var completeInfo: [String: Any] {
//        [
//            "address": address,
//            "birthDay": BirthDay(
//        ]
//    }
}
