//
//  RequestCommon.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/9/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class RequestCommon: NSObject {
    
    var Token: String?
    
    init(Token: String) {
        super.init()
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
        print("InDayRequestData :: \(dictionary.description)")
        return dictionary
    }
}
