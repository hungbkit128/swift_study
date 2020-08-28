//
//  ItemDashboardModel.swift
//  CBCT-Viettel
//
//  Created by Hoang on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class ItemDashboardModel: NSObject {

    var serviceId: Int?
    var itemName: String?
    var valueUp: Double?
    var valueBottom: Double?
    var unit: String?
    var warning: Bool?
    var listDataEntry: [ItemDashboardEntryModel]

    public init(_ dto: ItemDashboardDTO?) {

        serviceId   = dto?.serviceId
        itemName    = dto?.itemName
        valueUp     = dto?.valueUp
        valueBottom = dto?.valueBottom
        unit        = dto?.unit
        warning     = dto?.warning
        listDataEntry = []

        if let dataEntry = dto?.listDataEntry {
            for item in dataEntry {
                let model = ItemDashboardEntryModel(item)
                listDataEntry.append(model)
            }
        }
    }
}
