//
//  ItemDashBoardReportModel.swift
//  CBCT-Viettel
//
//  Created by GEM on 5/24/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class ItemDashBoardReportModel: ItemDashboardDataModel {
    var data: ReportDashboardModel?

    public override init(_ dto: DashboardDataDetailDTO) {

        if dto.data.isNull == false {
            let itemDTO = ReportDashboardDTO(dto.data)
            self.data = ReportDashboardModel(itemDTO)
        }

        super.init(dto)
    }

    func getfilterMetaData() -> FilterMetadataModel? {
        return data?.filterMetadata
    }
}
