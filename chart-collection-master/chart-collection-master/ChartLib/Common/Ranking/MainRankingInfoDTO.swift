//
//  MainRankingInfoDTO.swift
//  CBCT-Viettel
//
//  Created by Duong Thanh Tung on 11/18/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainRankingInfoDTO: NSObject {
    
    var currentRank: String?
    var unit: String?
    var lastRank: String?
    var deltaRank: Int?
    var level: String?

    init(_ json: JSON) {
        currentRank = json["currentRank"].string
        unit        = json["unit"].string
        lastRank    = json["lastRank"].string
        deltaRank   = json["deltaRank"].int
        level       = json["level"].string
    }
}
