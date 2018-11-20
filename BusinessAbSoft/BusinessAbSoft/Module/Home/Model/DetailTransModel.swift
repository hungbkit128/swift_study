//
//  DetailTransModel.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/14/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailTransModel: NSObject {
    
    var transModel: TransModel?
    var lstProductModel: [ProductModel] =  [ProductModel]()
    var lstAttackFileModel: [AttackFileModel] = [AttackFileModel]()
    
    init(_ jsonData: JSON) {
        transModel = TransModel(jsonData["TransModel"])
        lstProductModel = []
        lstAttackFileModel = []
        
        for (_, subJson) in jsonData["LstProductModel"] {
            DLog(subJson.description)
            let model = ProductModel(subJson)
            lstProductModel.append(model)
        }
        
        for (_, subJson) in jsonData["LstAttackFileModel"] {
            let model = AttackFileModel(subJson)
            lstAttackFileModel.append(model)
        }
    }
}
