//
//  PieceStyleModel.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class PieceStyleModel: NSObject {
    var styleId: Int?
    var color: String = ""
    var title: String = ""
    var objectID: String = ""
    var tableHeader: String = ""

    override init() {
        super.init()
    }

    init(_ dto: PieceStyleDTO) {
        styleId = dto.styleId
        color = dto.color
        title = dto.title
        objectID = dto.objectID
        tableHeader = dto.tableHeader
    }

    func clone() -> PieceStyleModel {
        let objClone = PieceStyleModel()
        objClone.styleId        = self.styleId
        objClone.color          = self.color
        objClone.title          = self.title
        objClone.objectID       = self.objectID
        objClone.tableHeader    = self.tableHeader
        return objClone
    }
}
