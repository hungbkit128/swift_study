//
//  ReportModelData.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/15/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class ReportModel: Codable {
    var IdUser:String?
    var CustomerName:String?
    var CustomerCode:String?
    var CustomerId:String?
    var Address:String?
    var Email:String?
    var PhoneNumber:String?
    var Token:String?
}

class ReportModelData: Codable {
    var ErrorCode:String?
    var Description:String?
    var LstReportModel:[ReportModel]?
}
