//
//  RankModel.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class RankModel: NSObject {

    var email: String?
    var rankingInfo: RankingInfoModel?
    var rankingBlockInfo: ReportDashboardModel?
    var chartTop5: GroupColumnChartModel?
    var chartBottom5: GroupColumnChartModel?
    var chartTopBottom: GroupColumnChartModel?
    var tableRanking: TableRankModel?
    var additionalMessage: String?
    var limitDate: Date?
    var currentFilter: RankingTypeModel

    init(_ dto: RankDTO) {

        email = dto.email
        if let data = dto.rankingInfo {
            rankingInfo = RankingInfoModel(rankingInfo: data)
        }

        if let data = dto.rankingBlockInfo {
            rankingBlockInfo = ReportDashboardModel(data)
        }

        if let data = dto.chartTop5 {
            chartTop5 = GroupColumnChartModel(data)
        }

        if let data = dto.chartBottom5 {
            chartBottom5 = GroupColumnChartModel(data)
        }

        if let data = dto.chartTopBottom {
            chartTopBottom = GroupColumnChartModel(data)
        }

        if let data = dto.tableRanking {
            tableRanking = TableRankModel(data)
        }

        if let mesage = dto.additionalMessage {
            additionalMessage = mesage
        }

        if let date = dto.limitDate {
            limitDate = Date.dateFromMiliseconds(miliSecond: date)
        }

        currentFilter = RankingTypeModel(dto.currentFilter)
    }
}
