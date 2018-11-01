//
//  InsertCusDataRequest.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/12/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class InsertCusRequestData: NSObject {
    
    var CustomerName: String?
    var Address: String?
    var Email: String?
    var PhoneNumber: String?
    var Token: String?
    
    override init() {
        super.init()
    }
    
    init(CustomerName:String, Address:String, Email:String, PhoneNumber:String, Token:String) {
        super.init()
        self.CustomerName = CustomerName
        self.Address = Address
        self.Email = Email
        self.PhoneNumber = PhoneNumber
        self.Token = Token
    }
    
    func toDictionary() -> [String : Any] {
        var dictionary = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                dictionary[key] = child.value
            }
        }
        print("RegisterRequestData :: \(dictionary.description)")
        return dictionary
    }
}

