//
//  ReportTypeResponseData.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/19/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class MBChartListModel: Codable {
    var ChartName:String?
    var ColumnText:String?
    var ColumnNumber:String?
    var LstMBChartListModels:[ReporTypeData]?
}

class ReporTypeData: Codable {
    var Key:String?
    var Value:String?
    var LstMBChartListModels:[MBChartListModel]?
}

class ReportTypeResponseData: Codable {
    var ErrorCode:String?
    var Description:String?
    var LstReportType:[ReporTypeData]?
}
