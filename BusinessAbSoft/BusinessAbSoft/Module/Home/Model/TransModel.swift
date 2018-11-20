//
//  TransModel.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/20/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import SwiftyJSON

class TransModel: NSObject {
    
    var implementerName: String?
    var customerName: String?
    var subject: String?
    var code: String?
    var title:String?
    var note: String?
    var typeName: String?
    var aCustomer: String?
    var implementName: String?
    var id: String?
    var createDate: String?
    
    init(_ jsonData: JSON) {
        self.implementerName = jsonData["ImplementerName"].string
        self.customerName = jsonData["CustomerName"].string
        self.subject = jsonData["Subject"].string
        self.code = jsonData["Code"].string
        self.title = jsonData["Title"].string
        self.note = jsonData["Note"].string
        self.typeName = jsonData["TypeName"].string
        self.aCustomer = jsonData["ACustomer"].string
        self.implementName = jsonData["ImplementName"].string
        self.id = jsonData["Id"].string
        self.createDate = jsonData["CreateDate"].string
    }
}
