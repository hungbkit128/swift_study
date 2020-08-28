//
//  LegendModel.swift
//  CBCT-Viettel
//
//  Created by Admin on 3/29/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

enum LegendType {
    case circle
    case square
    case line
    case lineCircle
    case lineDashed
    case avgLine
}

class LegendModel: NSObject {
    
    var color: String?
    var name: String?
    var isSelected: Bool?
    var objectId: String?
    var type: LegendType = .square
    var desc: String?
    var icon: UIImage?

    init(_ dto: ItemLineDTO) {
        color = dto.color
        name = dto.getLegendTitle()
        isSelected = false
        if let shape = dto.pointShapeName {
            icon = UIImage(named: shape)
        }
    }

    init(_ dto: ItemLineDTO, _ style: LegendType) {
        color = dto.color
        name = dto.getLegendTitle()
        isSelected = false
        type = style
        if let shape = dto.pointShapeName {
            icon = UIImage(named: shape)
        }
    }

    convenience init(_ color: String, _ name: String, _ tyle: LegendType?, _ icon: UIImage?) {
        self.init(color, name, "", tyle, icon)
        self.isSelected = false
    }

    init(_ color: String?, _ name: String?, _ objectId: String?, _ style: LegendType?, _ icon: UIImage?) {
        self.color = color
        self.name = name
        self.objectId = objectId
        self.icon = icon

        if let m = style {
            type = m
        }

        super.init()
    }

    init(_ color: String?, _ title: String, _ desc: String) {
        self.name = title
        self.desc = desc
        self.color = color
    }

    class func updateIsSelectedOfList(legends: [LegendModel], index: Int) {
        for (idx, item) in legends.enumerated() {
            if idx != index && item.isSelected == true {
                item.isSelected = false
            }
        }
    }

    func clone() -> LegendModel {
        let model = LegendModel(color, name, objectId, type, icon)
        return model
    }
    
}
