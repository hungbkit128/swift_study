//
//  RowDataModel.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class RowDataModel: NSObject {
    var mainContent: String
    var increase: Bool?
    var value: Double
    var color: String
    var dataInfo: RowDataInfoModel?
    var dataChart: ItemDashboardDataModel?
    var automatic: Int = 0

    init(_ dto: RowDataDTO) {
        mainContent = dto.mainContent
        increase = dto.increase
        value = dto.value
        color = dto.color
        automatic = dto.automatic

        if let data = dto.dataInfo {
            dataInfo = RowDataInfoModel(data)
        }
        if let data = dto.dataChart {
            dataChart = ItemDashboardDataModel.dataModelFromDTO(data)
        }
    }

    init(content: String, increase: Bool, value: Double, color: String) {
        self.mainContent = content
        self.increase = increase
        self.value = value
        self.color = color
    }

    func getAutomaticInfo() -> String? {
        if automatic == 1 {
            return LocalizableHelper.getTextByKey("dashboard.trend.target.automatic")
        } else if automatic == 2 {
            return LocalizableHelper.getTextByKey("dashboard.trend.target.automatic.part")
        }
        return nil
    }
}
