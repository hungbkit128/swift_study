//
//  TransData.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/15/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class TranModel: Codable {
    var JobReportTitle:String?
    var JobReportNote:String?
    var JobReportContent:String?
    var WorkDate:String?
    var WorkDataStr:String?
    var BusinessType:String?
    var Status:String?
    var UserId:String?
    var CustomerId:String?
    var ImplementerName:String?
}

class TransData: Codable {
    var ErrorCode:String?
    var Description:String?
    var LstTrans:[TranModel]?
}
