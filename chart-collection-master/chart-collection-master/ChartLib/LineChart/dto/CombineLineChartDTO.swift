//
//  CombineLineChartDTO.swift
//  CBCT-Viettel
//
//  Created by Admin on 6/9/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class CombineLineChartDTO: NSObject {
    
    var chartTitle: String?
    var left: LineChartDTO?
    var right: LineChartDTO?
    var objectType: String

    public init(_ json: JSON) {
        
        chartTitle = json["chartTitle"].stringValue

        if json["left"].isNull == false {
            left = LineChartDTO(json["left"])
        }

        if json["right"].isNull == false {
            right = LineChartDTO(json["right"])
        }

        objectType = json["objectType"].stringValue
    }
}
