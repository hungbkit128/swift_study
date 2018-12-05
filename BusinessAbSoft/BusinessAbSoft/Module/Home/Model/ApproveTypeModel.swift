//
//  ApproveTypeModel.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 12/5/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import SwiftyJSON

class ApproveTypeModel: NSObject {
    
    var value:String?
    var key:String?
    
    init(_ jsonData: JSON) {
        self.value = jsonData["Value"].string
        self.key = jsonData["Key"].string
    }
}
