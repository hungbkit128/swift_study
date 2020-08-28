//
//  NewContentDataDashboard.swift
//  CBCT-Viettel
//
//  Created by Nguyễn Việt on 6/10/19.
//  Copyright © 2019 Tung Duong Thanh. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewContentDataDashboard: NSObject {
    var listblock: [NewBlocklistDataDashboard]
    
    init(_ json: JSON){
        listblock = []
        for (_, subJson) in json["listBlock"] {
            let dto = NewBlocklistDataDashboard(subJson)
            listblock.append(dto)
        }
//        listblock = NewBlocklistDataDashboard(json["listBlock"])
        
    }
}
