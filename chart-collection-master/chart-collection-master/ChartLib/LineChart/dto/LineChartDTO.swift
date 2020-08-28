//
//  LineChartDTO.swift
//  CBCT-Viettel
//
//  Created by Viet Pham Duc on 2/21/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class LineChartDTO: NSObject {
    
    var chartTitle: String = ""
    var valueUnit: String = ""
    var lines: Array<ItemLineDTO>
    var hiddenLines: Array<ItemLineDTO>
    var avglines: Array<ItemLineDTO>
    var filterMetadataDTO: FilterMetadataDTO?
    var objectType: String
    var showLabel: Bool = false
    var commentData: CommentDataDTO?
    var haveComment: Bool?

    public init(_ json: JSON) {
        haveComment = json["haveComment"].bool
        if json["filterMetadata"].isNull == false {
            filterMetadataDTO = FilterMetadataDTO(json["filterMetadata"])
        }
        if (json["commentData"].isNull == false) {
            commentData = CommentDataDTO(json["commentData"])
        }
        chartTitle = json["chartTitle"].stringValue
        valueUnit = json["valueUnit"].stringValue
        if valueUnit.isEmpty {
            valueUnit = json["unit"].stringValue
        }

        lines = Array<ItemLineDTO>()
        for (_, subJson) in json["lines"].reversed() {
            let dto = ItemLineDTO(subJson)
            lines.append(dto)
        }

        hiddenLines = Array<ItemLineDTO>()
        for (_, subJson) in json["hiddenLines"].reversed() {
            let dto = ItemLineDTO(subJson)
            hiddenLines.append(dto)
        }

        avglines = Array<ItemLineDTO>()
        for (_, subJson) in json["avglines"] {
            let dto = ItemLineDTO(subJson)
            avglines.append(dto)
        }

        objectType = json["objectType"].stringValue
        showLabel = json["showLabel"].boolValue
    }
}
