//
//  NewDataPointDashBoard.swift
//  CBCT-Viettel
//
//  Created by Nguyễn Việt on 6/17/19.
//  Copyright © 2019 Tung Duong Thanh. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewDataPointDashBoard {
    var color: String?
    
    init(_ json: JSON) {
        color = json["color"].stringValue
    }
}
//"title": "AREA_CODE",
//"performValue": "TH",
//"drawValue": null,
//"showViewValue": "SHOW_VALUE_PERCENT",
//"calculateMethod": null,
//"color": "#29A19C",
//"type": null,
//"sortable": false,
//"hidden": false,
//"marker": null
