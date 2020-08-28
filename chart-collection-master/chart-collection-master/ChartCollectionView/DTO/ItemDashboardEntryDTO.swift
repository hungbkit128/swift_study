//
//  ItemDashboardEntryDTO.swift
//  CBCT-Viettel
//
//  Created by Hoang on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class ItemDashboardEntryDTO: NSObject {

    var itemName: String?
    var value: Double?
    var percent: String?
    var color: String?
    var increase: Bool?
    var delta: String?

    public init(_ json: JSON?) {
        itemName    = json?["itemName"].string
        value       = json?["value"].double
        percent     = json?["percent"].string
        color       = json?["color"].string
        increase    = json?["increase"].bool
        delta       = json?["deltaValue"].string
    }
}
