//
//  LoadDataResponseData.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/25/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class BusinessTypeModel: Codable {
    var Key:String?
    var Value:String?
}

class StatusModel: Codable {
    var Key:String?
    var Value:String?
}

class LoadDataResponseData: Codable {
    var ErrorCode:String?
    var Description:String?
    var LstBusinessType:[BusinessTypeModel]?
    var LstStatus:[StatusModel]?
}
