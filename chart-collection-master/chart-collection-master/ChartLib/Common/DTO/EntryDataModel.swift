//
//  EntryDataModel.swift
//  CBCT-Viettel
//
//  Created by Hoang on 4/28/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class EntryDataModel: NSObject {

    var chartName: String?
    var unit: String?
    var titleUnit: String?
    var entryName: String?
    var data: [LegendModel] = []
    var event: String?

    func getLegends() -> [LegendModel] {
        return data
    }

    func getTitleName() -> String? {
        if let title = entryName, let desc = event {
            if desc.count > 0 {
                return title + " - " + desc
            }

            return title
        }

        return entryName
    }
}
