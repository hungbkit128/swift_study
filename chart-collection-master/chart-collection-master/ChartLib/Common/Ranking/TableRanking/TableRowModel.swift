//
//  TableRowModel.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
open class TableRowModel: NSObject {
    var rowId: Int
    var objectId: String
    var rowData: [RowDataModel]
    var searchStr: String = ""
    var objectType: String?
    var groupId: String?

    var objectTypeEnum: AppObjectType {
        get {
            var result = AppObjectType.unknow
            if let type = objectType {
                result = AppObjectType.typeFromServer(type)
            }
            return result
        }
    }

    init(_ dto: TableRowDTO) {
        rowId = dto.rowId
        objectId = dto.objectId
        rowData = []
        searchStr = ""
        groupId = dto.groupId

        for rowDataDTO in dto.rowData {
            let model = RowDataModel(rowDataDTO)
            rowData.append(model)
            searchStr += " " + model.mainContent
        }
    }

    init(rowId: Int, objectId: String, rowData: [RowDataModel]) {
        self.rowId = rowId
        self.objectId = objectId
        self.rowData = rowData
    }
}
