//
//  LoginRequestData.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/16/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class LoginRequestData: NSObject {
    
    var UserName: String?
    var PassWord: String?
    //var AccountId: String?
    //var IdImplementer: String?
    //var Token: String?
    //var RequestDate: String?
    var Imei: String?
    var Model: String?
    
    override init() {
        super.init()
    }
    
    init(UserName:String, PassWord:String) {
        super.init()
        
        self.UserName = UserName
        self.PassWord = PassWord
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
