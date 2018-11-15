//
//  UserInfoModel.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/14/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserInfoModel: NSObject {
    
    var Token:String?
    var AccountId:String?
    var IdImplementer:String?
    var UserName:String?
    
    init(_ jsonData: JSON) {
        self.Token = jsonData["Token"].string
        self.AccountId = jsonData["AccountId"].string
        self.IdImplementer = jsonData["IdImplementer"].string
        self.UserName = jsonData["UserName"].string
    }
}
