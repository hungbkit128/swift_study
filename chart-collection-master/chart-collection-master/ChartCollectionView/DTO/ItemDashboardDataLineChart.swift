//
//  ItemDashboardLineChartModel.swift
//  CBCT-Viettel
//
//  Created by Hoang on 4/24/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class ItemDashboardDataLineChart: ItemDashboardDataModel {
    
    var data: LineChartModel?

    public override init(_ dto: DashboardDataDetailDTO) {
        
        let lineChartDTO = LineChartDTO(dto.data)
        data = LineChartModel(lineChartDTO)
        super.init(dto)
        data?.uuid = self.uuid
    }

    init(combineLineDTO: DashboardDataDetailDTO) {
        let dto = CombineLineChartDTO(combineLineDTO.data)
        data = LineChartModel(combineDTO: dto)
        super.init(combineLineDTO)
    }

    init(lineDTO: LineChartDTO) {
        data = LineChartModel(lineDTO)
        super.init()
        self.type = DashboardDetailType.lineChart
    }

    init(combineChartData: ItemDashboardDataCombineBarChart) {
        super.init()
        if let dto = combineChartData.lineChartDTO {
            data = LineChartModel(dto)
            data?.chartTitle = combineChartData.chartName
        }
        self.type = DashboardDetailType.lineChart
    }
}
