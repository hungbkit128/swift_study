//
//  HeaderModel.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class HeaderModel: NSObject {

    var columnId: Int
    var columnName: String
    var type: String
    var sortable: Bool? = nil
    var isVisible: Bool = true
    
    init(_ dto: HeaderDTO) {
        columnName = dto.columnName
        type = dto.type
        sortable = dto.sortable!
        columnId = dto.columnId
    }
}
