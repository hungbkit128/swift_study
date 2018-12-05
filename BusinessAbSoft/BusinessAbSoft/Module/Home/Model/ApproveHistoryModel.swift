//
//  ApproveHistoryModel.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/26/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import SwiftyJSON

class ApproveHistoryModel: NSObject {
    
    var implementerName:String?
    var confirmName:String?
    var confirmDate:String?
    var confirmNote:String?
    var id:Int?
    
    init(_ jsonData: JSON) {
        self.implementerName = jsonData["ImplementerName"].string
        self.confirmName = jsonData["ConfirmName"].string
        self.confirmDate = jsonData["ConfirmDate"].string
        self.confirmNote = jsonData["ConfirmNote"].string
        self.id = jsonData["Id"].int
    }
}
