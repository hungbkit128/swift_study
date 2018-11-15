//
//  RegisterRequestData.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/15/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class RegisterRequestData: NSObject {
    //var Id: Int?
    var CustName: String?
    //var CustCode: String?
    var Email: String?
    var Isdn: String?
    var Imei: String?
    var Model: String?
    //var RegisterDate: String?
    //var ActiveDate: String?
    //var TrialDate: String?
    //var Status: Int?
    //var CompanyId: Int?
    var CompanyName: String?
    
    override init() {
        super.init()
    }
    
    init(CustName:String) {
        super.init()
        self.CustName = CustName
    }
    
    func toDictionary() -> [String : Any] {
        var dictionary = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                dictionary[key] = child.value
            }
        }
        print("USER_DICTIONARY :: \(dictionary.description)")
        return dictionary
    }
}
