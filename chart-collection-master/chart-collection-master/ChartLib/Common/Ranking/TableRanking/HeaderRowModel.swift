//
//  HeaderRowModel.swift
//  
//
//  Created by Admin on 3/15/18.
//

import UIKit

open class HeaderRowModel: NSObject {

    var headerId: String
    var headerName: String
    var typeGroup: GroupTargetTrends = .unknown
    var type: String?
    var rowStart: Int = 0
    var rowsCount: Int = 1
    var groupId: String?

    init(_ dto: HeaderRowDTO) {
        headerId    = dto.headerId
        headerName  = dto.headerName
        type        = dto.type
        if let keyType = dto.type {
            typeGroup = GroupTargetTrends.typeFromServer(keyType)
        }
        groupId     = dto.groupId
    }

    func updateRowStart(_ startIndex: Int) {
        rowStart = startIndex
    }

    func updateRowCount(_ count: Int) {
        rowsCount = count
    }
}
