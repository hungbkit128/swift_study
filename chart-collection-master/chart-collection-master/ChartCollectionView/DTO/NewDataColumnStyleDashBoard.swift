//
//  NewDataColumnStyleDashBoard.swift
//  CBCT-Viettel
//
//  Created by Nguyễn Việt on 6/17/19.
//  Copyright © 2019 Tung Duong Thanh. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewDataColumnStyleDashBoard {
    var point: [NewDataPointDashBoard]
    
    init(_ json: JSON) {
        point = []
        
        for (_, subjson) in json["points"] {
            let data = NewDataPointDashBoard(subjson)
            point.append(data)
        }
    }
}
