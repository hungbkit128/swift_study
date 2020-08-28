//
//  ItemDashboardDataStackBarChart.swift
//  CBCT-Viettel
//
//  Created by GEM on 4/29/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class ItemDashboardDataStackBarChart: ItemDashboardDataModel {

    var data: GVerticalStackBarChartData?
    var showLabel: Bool
    
    var commentData: CommentDataDTO?
    var haveComment: Bool?

    public override init(_ dto: DashboardDataDetailDTO) {

        let json = dto.data
        showLabel = json["showLabel"].boolValue
        
        haveComment = json["haveComment"].bool
        if (json["commentData"].isNull == false) {
            commentData = CommentDataDTO(json["commentData"])
        }

        let currentType = ViewTypeDTO(json["currentType"])
        var viewTypes: [ViewTypeDTO] = []
        for (_, subJson) in json["viewTypes"] {
            let viewTypeDTO = ViewTypeDTO(subJson)
            viewTypes.append(viewTypeDTO)
        }
        let asc = json["asc"].bool

        let stackBarChartDTO = GroupColumnChartDTO(json["chartData"])
        data = GVerticalStackBarChartViewMapping.mappingDataFromDTO(stackBarChartDTO, currentType, viewTypes, asc)
        data?.commentData = self.commentData
        data?.haveComment = self.haveComment
        if json["filterMetadata"].isNull == false {
            let filterMetaDataDTO = FilterMetadataDTO(json["filterMetadata"])
            let filterMetaDataModel = FilterMetadataModel(filterMetaDataDTO)
            data?.filterMetaData = filterMetaDataModel
            data?.unitDescription = filterMetaDataModel.getUnitDescription()
        }

        data?.createSearchCretieria()

        super.init(dto)
        data?.uuid = self.uuid
    }

    func getfilterMetaData() -> FilterMetadataModel? {
        return data?.filterMetaData
    }
}
