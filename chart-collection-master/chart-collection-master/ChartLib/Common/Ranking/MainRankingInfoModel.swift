//
//  MainRankingInfoModel.swift
//  CBCT-Viettel
//
//  Created by Duong Thanh Tung on 11/18/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class MainRankingInfoModel: NSObject {
    var currentRank: String?
    var unit: String?
    var lastRank: String?
    var deltaRank: Int?
    var level: String?

    init(_ dto: MainRankingInfoDTO) {
        currentRank = dto.currentRank
        unit        = dto.unit
        lastRank    = dto.lastRank
        deltaRank   = dto.deltaRank
        level       = dto.level
    }
}
