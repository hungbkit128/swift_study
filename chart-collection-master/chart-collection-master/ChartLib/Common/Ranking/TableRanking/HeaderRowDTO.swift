//
//  HeaderRowDTO.swift
//  CBCT-Viettel
//
//  Created by Admin on 3/15/18.
//  Copyright © 2018 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class HeaderRowDTO: NSObject {

    var headerId: String
    var headerName: String
    var type: String?
    var groupId: String?

    init(_ json: JSON) {
        headerId    = json["id"].stringValue
        headerName  = json["name"].stringValue
        type        = json["type"].string
        if json["groupId"].stringValue != "null" {
            groupId     = json["groupId"].stringValue
        }
    }
}
