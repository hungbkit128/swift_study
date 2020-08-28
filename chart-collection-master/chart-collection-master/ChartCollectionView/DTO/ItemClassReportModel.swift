//
//  ItemClassReportModel.swift
//  CBCT-Viettel
//
//  Created by GEM on 9/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class ItemClassReportModel: ItemDashboardDataModel {
    
    var data: ReportDashboardModel?

    public override init(_ dto: DashboardDataDetailDTO) {
        if dto.data.isNull == false {
            let itemDTO = ReportDashboardDTO(dto.data)
            self.data = ReportDashboardModel(itemDTO)
        }
        super.init(dto)
    }
}
