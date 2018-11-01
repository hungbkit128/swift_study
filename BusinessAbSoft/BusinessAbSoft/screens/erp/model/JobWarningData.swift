//
//  JobWarningData.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/8/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class JobData: Codable {
    var Content:String?
    var CustomerName:String?
    var DateWarning:String?
    var JobId:String?
    var JobType:String?
    var UserImplement:String?
}

class JobWarningData: Codable {
    var ErrorCode:String?
    var Description:String?
    var LstJobWarning:[JobData]?
}
