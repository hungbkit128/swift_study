//
//  RankDTO.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class RankDTO: NSObject {

    var email: String?
    var limitDate: Double?
    var additionalMessage: String?
    var rankingInfo: RankingInfoDTO?
    var rankingBlockInfo: ReportDashboardDTO?
    var chartTop5: GroupColumnChartDTO?
    var chartBottom5: GroupColumnChartDTO?
    var chartTopBottom: GroupColumnChartDTO?
    var tableRanking: TableRankDTO?
    var currentFilter: RankingTypeDTO

    init(_ json: JSON) {

        email = json["email"].string
        if json["rankingInfo"] != JSON.null {
            rankingInfo = RankingInfoDTO(json["rankingInfo"])
        }

        if json["rankingReport"] != JSON.null {
            rankingBlockInfo = ReportDashboardDTO(json["rankingReport"])
        }

        if json["chartTop5"] != JSON.null {
            chartTop5 = GroupColumnChartDTO(json["chartTop5"])
        }

        if json["chartBottom5"] != JSON.null {
            chartBottom5 = GroupColumnChartDTO(json["chartBottom5"])
        }

        if json["chartTopBottom"] != JSON.null {
            chartTopBottom = GroupColumnChartDTO(json["chartTopBottom"])
        }

        if json["tableRanking"] != JSON.null {
            tableRanking = TableRankDTO(json["tableRanking"])
        }

        if json["additionalInfo"] != JSON.null {
            additionalMessage = json["additionalInfo"].stringValue
        }

        if json["limitDate"] != JSON.null {
            limitDate = json["limitDate"].doubleValue
        }

        currentFilter = RankingTypeDTO(json["currentFilter"])
    }
}
