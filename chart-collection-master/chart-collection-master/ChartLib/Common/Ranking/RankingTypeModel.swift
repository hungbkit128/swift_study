//
//  GroupRankingModel.swift
//  CBCT-Viettel
//
//  Created by Admin on 11/1/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class RankingTypeModel: NSObject {
    var key: String = ""
    var name: String = ""

    override init() {
        super.init()
    }

    init(_ dto: RankingTypeDTO) {
        self.key = dto.key
        self.name = dto.name
    }

    init(key: String, name: String) {
        self.key = key
        self.name = name
    }

    func clone() -> RankingTypeModel {
        let objClone = RankingTypeModel()
        objClone.key = self.key
        objClone.name = self.name
        return objClone
    }

    static func == (left: RankingTypeModel, right: RankingTypeModel) -> Bool {
        return left.key == right.key
    }

    class func initRankingType(withkey key: String) -> RankingTypeModel? {
        let rankingType = DataManager.shareInstance.rankingType
        if let type = rankingType.first(where: {$0.key.trim() == key.trim()}) {
            return type
        }
        return RankingTypeModel(key: key, name: "")
    }

    func isSelected(_ item: RankingTypeModel?) -> Bool {
        if let current = item {
            return self.key == current.key
        }
        return false
    }

}
