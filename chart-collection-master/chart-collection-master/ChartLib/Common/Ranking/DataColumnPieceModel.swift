//
//  DataColumnPieceModel.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class DataColumnPieceModel: NSObject {
    var styleId: Int?
    var value: Double?
    var percent: Double?
    var drawValue: Double?
    var viewValue = ""
    override init() {
        super.init()
    }

    init(_ dto: DataColumnPieceDTO) {
        styleId = dto.styleId
        value = dto.value
        percent = dto.percent
        drawValue = dto.drawValue
        viewValue = dto.viewValue
    }

    func clone() -> DataColumnPieceModel {
        let objClone = DataColumnPieceModel()
        objClone.styleId = self.styleId
        objClone.value = self.value
        objClone.percent = self.percent
        objClone.drawValue = self.drawValue
        objClone.viewValue = self.viewValue
        return objClone
    }
}
