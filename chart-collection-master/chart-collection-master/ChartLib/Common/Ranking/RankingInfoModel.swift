//
//  RankingInfoModel.swift
//  CBCT-Viettel
//
//  Created by Duong Thanh Tung on 11/18/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class RankingInfoModel: ReportDashboardModel {
    
    var rankingBlock: [MainRankingInfoModel] = []
    var subTitle: String?
    var lblSubTitleDate : String?

    override init(_ dto: ReportDashboardDTO) {
        super.init(dto)
    }

    convenience init(rankingInfo: RankingInfoDTO) {
        self.init(rankingInfo)
        for item in rankingInfo.rankingBlock {
            self.rankingBlock.append(MainRankingInfoModel.init(item))
        }
    }
}
