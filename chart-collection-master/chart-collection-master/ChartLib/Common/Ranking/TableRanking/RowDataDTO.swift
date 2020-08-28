//
//  RowDataDTO.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class RowDataDTO: NSObject {

    var mainContent: String
    var increase: Bool?
    var value: Double
    var color: String
    var dataInfo: RowDataInfoDTO?
    var dataChart: DashboardDataDetailDTO?
    var automatic: Int

    init(_ json: JSON) {
        mainContent = json["mainContent"].stringValue
        increase = json["increase"].bool
        value = json["value"].doubleValue
        color = json["color"].stringValue
        automatic = json["automatic"].intValue

        if !json["dataInfo"].isNull {
            dataInfo = RowDataInfoDTO(json["dataInfo"])
        }

        if !json["dataChart"].isNull {
            dataChart = DashboardDataDetailDTO(json["dataChart"])
        }
    }

}
