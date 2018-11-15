//
//  GroupReportData.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/18/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class GroupReport: Codable {
    var Key:String?
    var Value:String?
}

class GroupReportData: Codable {
    var ErrorCode:String?
    var Description:String?
    var LstGroupReport:[GroupReport]?
}
