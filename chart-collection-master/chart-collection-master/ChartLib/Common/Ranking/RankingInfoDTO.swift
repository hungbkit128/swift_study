//
//  RankingInfoDTO.swift
//  CBCT-Viettel
//
//  Created by Duong Thanh Tung on 11/18/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class RankingInfoDTO: ReportDashboardDTO {

    var rankingBlock: [MainRankingInfoDTO] = []

    override init(_ json: JSON) {
        super.init(json)
        for (_, subJson) in json["rankingBlock"] {
            let dto = MainRankingInfoDTO(subJson)
            rankingBlock.append(dto)
        }
    }
}
