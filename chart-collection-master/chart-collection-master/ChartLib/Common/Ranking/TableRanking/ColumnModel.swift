//
//  ColumnModel.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class ColumnModel: NSObject {
    var label: String
    var value: Double
    var percent: Double
    var dataColumnPieces: [DataColumnPieceModel]

    init(_ dto: ColumnDTO) {
        label = dto.label
        value = dto.value
        percent = dto.percent
        dataColumnPieces = []
        for dataColumnPiece in dto.dataColumnPieces {
            dataColumnPieces.append(DataColumnPieceModel(dataColumnPiece))
        }
    }

    func getTotalPercentOfColum() -> Double {
        var result: Double = 0.0
        for dataColumn in dataColumnPieces {
            if let percent = dataColumn.percent {
                result += percent
            }
        }

        return result
    }
}
