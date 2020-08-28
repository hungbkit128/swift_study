//
//  DashboardDetailDTO.swift
//  CBCT-Viettel
//
//  Created by Hoang on 4/24/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class DashboardDataDetailDTO: NSObject {
    
    var blockId: String?
    var type: DashboardDetailType
    var data: JSON
    var groupId: String
    var size: String?

    public init(_ json: JSON) {
        type = DashboardDetailType.fromString(json["type"].stringValue)
        data = json["data"]
        groupId = json["blockId"].stringValue
        size = json["size"].string
        blockId = json["blockId"].stringValue
    }
}
