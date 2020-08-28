//
//  RowDataInfoDTO.swift
//  CBCT-Viettel
//
//  Created by Admin on 1/16/18.
//  Copyright © 2018 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class RowDataInfoDTO: NSObject {
    var planValue: String?
    var performValue: String?
    var performPercent: Double?
    var performColor: String?
    var deltaValue: String?
    var deltaPercent: String?
    var deltaColor: String?
    var increase: Bool?
    var unit: String?
    var completedType: String?

    init(_ json: JSON) {
        planValue       = json["planValue"].string
        performValue    = json["performValue"].string
        performPercent  = json["performPercent"].double
        performColor    = json["performColor"].string
        deltaValue      = json["deltaValue"].string
        deltaPercent    = json["deltaPercent"].string
        deltaColor      = json["deltaColor"].string
        increase        = json["increase"].bool
        unit            = json["unit"].string
        completedType    = json["completedType"].string
    }
}
