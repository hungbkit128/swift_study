//
//  SearchHistoryRequestData.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/15/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class SearchHistRequestData: NSObject {
    
    var IdCustomer: String?
    var Token: String?
    
    override init() {
        super.init()
    }
    
    init(IdCustomer:String, Token:String) {
        super.init()
        self.IdCustomer = IdCustomer
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
        print("SearchHistRequestData :: \(dictionary.description)")
        return dictionary
    }
}
