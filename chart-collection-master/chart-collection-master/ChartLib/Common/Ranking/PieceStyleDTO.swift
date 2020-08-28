//
//  PieceDTO.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class PieceStyleDTO: NSObject {

    var styleId: Int?
    var color: String = ""
    var title: String = ""
    var objectID: String = ""
    var tableHeader: String = ""

    override init() {
        super.init()
    }

    init(_ json: JSON) {
        styleId = json["id"].intValue
        color = json["color"].stringValue
        title = json["title"].stringValue
        objectID = json["objectID"].stringValue
        if objectID.isEmpty {
            objectID = json["objectId"].stringValue
        }
        tableHeader = json["tableHeader"].stringValue
    }

    init(_ styleId: Int, _ color: String, _ title: String, _ objectId: String, _ tableHeader: String = "") {
        self.styleId        = styleId
        self.color          = color
        self.title          = title
        self.objectID       = objectId
        self.tableHeader    = tableHeader
    }
}
