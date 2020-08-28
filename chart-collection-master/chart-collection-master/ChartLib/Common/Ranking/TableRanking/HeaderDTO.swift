//
//  HeaderDTO.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class HeaderDTO: NSObject {

    var columnName: String
    var type: String
    var sortable: Bool? = nil
    var columnId: Int
    
    init(_ json: JSON) {
        columnName = json["columnName"].stringValue
        type = json["type"].stringValue
        sortable = json["sortable"].boolValue
        columnId = json["columnId"].intValue
    }
}
