//
//  ItemDashboardDataRankingModel.swift
//  CBCT-Viettel
//
//  Created by Admin on 5/31/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class ItemDashboardDataRankingModel: ItemDashboardDataModel {

    var rankingData: RankingTableModel?
    var filterMetadata: FilterMetadataModel?

    public override init(_ dto: DashboardDataDetailDTO) {
        let rankingDTO = TableRankDTO(dto.data)
        let model = TableRankModel(rankingDTO)
        rankingData = GSPReadSheetViewDataMapping.mappingFromTableRankModel(model)
        filterMetadata = FilterMetadataModel(FilterMetadataDTO(dto.data["filterMetadata"]))
        super.init(dto)
    }

    init(ranking: RankingTableModel) {
        super.init()
        rankingData = ranking
    }
}
