//
//  ReportDashboardDTO.swift
//  CBCT-Viettel
//
//  Created by GEM on 5/24/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReportDashboardDTO: NSObject {

    var reportName: String?
    var unit: String?
    var mainBlock: MainBlockDTO?
    var otherInfo: [InfoDTO] = []
    var sparkLines: ItemDashboardDataLineChart?

    init(_ json: JSON) {
        reportName = json["reportName"].string
        unit = json["unit"].string
        mainBlock = MainBlockDTO(json["mainBlock"])
        sparkLines = ItemDashboardDataLineChart(DashboardDataDetailDTO(json["sparkLines"]))
        for (_, subJson) in json["otherInfo"] {
            let dto = InfoDTO(subJson)
            otherInfo.append(dto)
        }
    }
}

class UnitDTO: NSObject {
    var group: String?
    var province: String?
    var district: String?
    var station: String?
    var deptLevel: Int?

    init(_ json: JSON) {
        group = json["group"].string
        province = json["province"].string
        district = json["district"].string
        station = json["station"].string
        deptLevel = json["deptLevel"].int
    }
}

class MainBlockDTO: NSObject {
    var performValue: String?
    var planValue: String?
    var performPercent: Double?
    var performColor: String?
    var prettyPlanValue: String?
    var prettyPerformValue: String?
    var prettyUnit: String?

    init(_ json: JSON) {
        performValue        = json["performValue"].string
        planValue           = json["planValue"].string
        performPercent      = json["performPercent"].double
        performColor        = json["performColor"].string
        prettyPlanValue     = json["prettyPlanValue"].string
        prettyPerformValue  = json["prettyPerformValue"].string
        prettyUnit          = json["prettyUnit"].string
    }
}

class InfoDTO: NSObject {
    var type: ReportInfo
    var data: JSON

    public init(_ json: JSON) {
        type = ReportInfo.fromString(json["type"].stringValue)
        data = json["data"]
    }
}
