//
//  GetDetailRequestData.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/22/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class ViewDetailRequestData: NSObject {
    
    var Token: String?
    var JobId:String?
    var JobType:String?
    
    override init() {
        super.init()
    }
    
    init(JobId:String, JobType:String, Token:String) {
        super.init()
        self.JobId = JobId
        self.JobType = JobType
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
        print("ViewDetailRequestData :: \(dictionary.description)")
        return dictionary
    }
}
