//
//  ItemDashboardDataGroupBarChart.swift
//  CBCT-Viettel
//
//  Created by Hoang on 4/24/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class ItemDashboardDataGroupBarChart: ItemDashboardDataModel {

    var data: GGroupBarChartViewData?

    public override init(_ dto: DashboardDataDetailDTO) {

        let groupChartDTO = GroupBarChartDTO(dto.data)
        data = GGroupBarChartViewMapping.mappingDataFromDTO(groupChartDTO)
        if dto.data["filterMetadata"].isNull == false {
            let filterMetaDataDTO = FilterMetadataDTO(dto.data["filterMetadata"])
            let filterMetaDataModel = FilterMetadataModel(filterMetaDataDTO)
            data?.filterMetaData = filterMetaDataModel
            data?.unitDescription = filterMetaDataModel.getUnitDescription()
            data?.creteSearchCretieria()
        }

        super.init(dto)
        data?.uuid = self.uuid
    }

    func getfilterMetaData() -> FilterMetadataModel? {
        return data?.filterMetaData
    }
}
