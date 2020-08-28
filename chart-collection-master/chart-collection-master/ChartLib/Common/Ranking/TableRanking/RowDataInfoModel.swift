//
//  RowDataInfoModel.swift
//  CBCT-Viettel
//
//  Created by Admin on 1/16/18.
//  Copyright © 2018 Tung Duong Thanh. All rights reserved.
//

import UIKit

class RowDataInfoModel: NSObject {
    var planValue: String?
    var performValue: String?
    var performPercent: Double?
    var performColor: String?
    var deltaValue: String?
    var deltaPercent: String?
    var deltaColor: String?
    var increase: Bool?
    var unit: String?
    var completedType: CompletedType = .unknown

    init(_ dto: RowDataInfoDTO) {
        planValue       = dto.planValue
        performValue    = dto.performValue
        performPercent  = dto.performPercent
        performColor    = dto.performColor
        deltaValue      = dto.deltaValue
        deltaPercent    = dto.deltaPercent
        deltaColor      = dto.deltaColor
        increase        = dto.increase
        unit            = dto.unit
        if let type = dto.completedType {
            completedType = CompletedType.typeFromServer(type)
        }
    }
}
