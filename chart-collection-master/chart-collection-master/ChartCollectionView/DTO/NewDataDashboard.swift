//
//  NewDataDashboard.swift
//  CBCT-Viettel
//
//  Created by Nguyễn Việt on 6/10/19.
//  Copyright © 2019 Tung Duong Thanh. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewDataDashboard: NSObject  {
    var errorCode: String?
    var errorMessage: String?
    var content: NewContentDataDashboard?
    
    override init(){}
    
    init(_ json: JSON){
        errorCode = json["errorCode"].string
        errorMessage = json["errorMessage"].string
        content = NewContentDataDashboard(json["content"])
    }
}

//"errorCode": "SUCCESS",
//"errorMessage": "Thành công",    
//"content": {
