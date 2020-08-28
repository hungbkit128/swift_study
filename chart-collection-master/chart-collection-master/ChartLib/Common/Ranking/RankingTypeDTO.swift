//
//  GroupRankingDTO.swift
//  CBCT-Viettel
//
//  Created by admin on 11/2/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class RankingTypeDTO: NSObject {
    var key: String
    var name: String

    init(_ json: JSON) {
        key = json["key"].stringValue
        name = json["name"].stringValue
    }
}
