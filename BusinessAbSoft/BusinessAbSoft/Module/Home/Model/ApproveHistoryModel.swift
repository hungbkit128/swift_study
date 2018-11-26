//
//  ApproveHistoryModel.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/26/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit

class ApproveHistoryModel: NSObject {
    
    var aAttackFile:String?
    var fileName:String?
    var fileContent:String?
    
    init(_ jsonData: JSON) {
        self.aAttackFile = jsonData["AAttackFile"].string
        self.fileName = jsonData["FileName"].string
        self.fileContent = jsonData["FileContent"].string
    }
}
