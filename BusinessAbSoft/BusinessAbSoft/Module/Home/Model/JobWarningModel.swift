//
//  JobWarningModel.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/27/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import SwiftyJSON

class JobWarningModel: NSObject {
    
    var content:String?
    var customerName:String?
    var dateWarning:String?
    var jobId:String?
    var jobType:String?
    var userImplement:String?
    
    init(_ jsonData: JSON) {
        self.content = jsonData["Content"].string
        self.customerName = jsonData["CustomerName"].string
        self.dateWarning = jsonData["DateWarning"].string
        self.jobId = jsonData["JobId"].string
        self.jobType = jsonData["JobType"].string
        self.userImplement = jsonData["UserImplement"].string
    }
}
