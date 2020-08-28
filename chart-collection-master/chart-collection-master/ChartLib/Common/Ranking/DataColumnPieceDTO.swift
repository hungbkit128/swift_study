//
//  DataColumnPieceDTO.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class DataColumnPieceDTO: NSObject {

    var styleId: Int?
    var value: Double?
    var percent: Double?
    var drawValue: Double?
    var viewValue: String

    init(_ json: JSON) {
        styleId = json["styleId"].int
        value = json["value"].doubleValue
        percent = json["percent"].double
        drawValue = json["drawValue"].double
        viewValue = json["viewValue"].stringValue
    }
}
