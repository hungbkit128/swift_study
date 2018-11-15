//
//  InitReportTypeRequest.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/19/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class InitReportTypeRequest: NSObject {
    
    var GroupReportId: String?
    var Token: String?
    
    override init() {
        super.init()
    }
    
    init(GroupReportId:String, Token:String) {
        super.init()
        self.GroupReportId = GroupReportId
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
        print("InitReportTypeRequest :: \(dictionary.description)")
        return dictionary
    }
}

