//
//  ItemDashboardDataStackBarChart.swift
//  CBCT-Viettel
//
//  Created by GEM on 4/29/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class ItemDashboardDataHorizontalStackBarChart: ItemDashboardDataModel {

    var data: GVerticalStackBarChartData?
    var asc: Bool = false

    public override init(_ dto: DashboardDataDetailDTO) {

        let json = dto.data

        let currentType = ViewTypeDTO(json["currentType"])
        var viewTypes: [ViewTypeDTO] = []
        for (_, subJson) in json["viewTypes"] {
            let viewTypeDTO = ViewTypeDTO(subJson)
            viewTypes.append(viewTypeDTO)
        }
        asc = json["asc"].boolValue

        let stackBarChartDTO = GroupColumnChartDTO(json["chartData"])
        data = GVerticalStackBarChartViewMapping.mappingDataRankingFromDTO(stackBarChartDTO, currentType, viewTypes, asc)
        data?.subTitle = json["subTitle"].stringValue
        if json["filterMetadata"].isNull == false {
            let filterMetaDataDTO = FilterMetadataDTO(json["filterMetadata"])
            let filterMetaDataModel = FilterMetadataModel(filterMetaDataDTO)
            data?.filterMetaData = filterMetaDataModel
            data?.unitDescription = filterMetaDataModel.getUnitDescription()
        }

        data?.createSearchCretieria()

        super.init(dto)
    }

    func getfilterMetaData() -> FilterMetadataModel? {
        return data?.filterMetaData
    }
}
