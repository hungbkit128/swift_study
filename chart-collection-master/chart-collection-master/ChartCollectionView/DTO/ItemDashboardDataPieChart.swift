//
//  ItemDashboardDataPieChart.swift
//  CBCT-Viettel
//
//  Created by Hoang on 4/24/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class ItemDashboardDataPieChart: ItemDashboardDataModel {

    var data: PieChartModel?

    public override init(_ dto: DashboardDataDetailDTO) {

        data = GPieChartViewMapping.mappingDataFromDashboardItemDTO(dto)
        super.init(dto)
    }

    func getfilterMetaData() -> FilterMetadataModel? {
        return data?.filterMetaData
    }
}
