//
//  ItemLineDTO.swift
//  CBCT-Viettel
//
//  Created by Viet Pham Duc on 2/21/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Charts

class ItemLineDTO: NSObject {
    
    var title: String = ""
    var info: Array<InfoLineItemDTO>
    var color: String = ""
    var points: Array<PointDTO>
    
    var average: Bool = true
    var keyCommentList: [String]
    var dateList: [String]
    var pointShapeName: String?

    public init(_ json: JSON) {
        title = json["title"].stringValue
        info = Array<InfoLineItemDTO>()
        for (_, subJson) in json["info"] {
            let dto = InfoLineItemDTO(subJson)
            info.append(dto)
        }
        color = json["color"].stringValue
        points = Array<PointDTO>()
        for (_, subJson) in json["points"] {
            let dto = PointDTO(subJson)
            points.append(dto)
        }

        keyCommentList = []
        dateList = []
        for item in points {
            if let keyComment = item.keyComment {
                keyCommentList.append(keyComment)
            }
            dateList.append(item.date)
        }
        average = json["average"].boolValue
        pointShapeName = json["pointShapeName"].stringValue
    }

    func getLegendTitle() -> String? {
        var legendTitle: String = self.title
        if info.count > 0 {
            var listInfor: [String] = [String]()
            for item in info {
                let desc = item.key + ": " + item.value
                listInfor.append(desc)
            }
            legendTitle += "\n("
            legendTitle += listInfor.joined(separator: " - ")
            legendTitle +=  ")"
        }
        return legendTitle
    }
}
