//
//  ItemDashboardDTO.swift
//  CBCT-Viettel
//
//  Created by Hoang on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class ItemDashboardDTO: NSObject {

    var serviceId: Int?
    var itemName: String?
    var valueUp: Double?
    var valueBottom: Double?
    var unit: String?
    var warning: Bool?
    var listDataEntry: [ItemDashboardEntryDTO]

    public init(_ json: JSON) {
        serviceId       = json["serviceId"].int
        itemName        = json["itemName"].string
        valueUp         = json["valueUp"].double
        valueBottom     = json["valueBottom"].double
        unit            = json["unit"].string
        warning         = json["warning"].bool

        listDataEntry = []
        for (_, subJson) in json["listDataEntry"] {
            let entry = ItemDashboardEntryDTO(subJson)
            listDataEntry.append(entry)
        }
    }
}
