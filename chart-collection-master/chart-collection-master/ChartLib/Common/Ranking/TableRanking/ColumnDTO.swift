//
//  ColumnDTO.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class ColumnDTO: NSObject {

    var label: String
    var event: String
    var value: Double
    var percent: Double
    var dataColumnPieces: [DataColumnPieceDTO]
    var keyComment: String
    var titleComment: String
    var dateValue: String
    var serviceId: String
    init(_ json: JSON) {
        serviceId = json["serviceId"].stringValue
        label = json["label"].stringValue
        event = json["event"].stringValue
        value = json["value"].doubleValue
        percent = json["percent"].doubleValue
        keyComment = json["keyComment"].stringValue
        dateValue = json["dateValue"].stringValue
        titleComment = json["titleComment"].stringValue
        dataColumnPieces = []
        for (_, subJson) in json["dataColumnPieces"] {
            let dto = DataColumnPieceDTO(subJson)
            dataColumnPieces.append(dto)
        }

    }
}
