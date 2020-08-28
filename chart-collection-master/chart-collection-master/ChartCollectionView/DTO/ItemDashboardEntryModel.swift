//
//  ItemDashboardEntryModel.swift
//  CBCT-Viettel
//
//  Created by Hoang on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class ItemDashboardEntryModel: NSObject {

    var itemName: String?
    var value: Double?
    var percent: String?
    var color: UIColor?
    var increase: Bool?
    var delta: String?

    public init(_ dto: ItemDashboardEntryDTO?) {

        itemName    = dto?.itemName
        value       = dto?.value
        percent     = dto?.percent
        if let col = dto?.color {
            self.color   = AppColor.colorFromHex(col)
        }
        increase    = dto?.increase
        delta       = dto?.delta
    }
}
