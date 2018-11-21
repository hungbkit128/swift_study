//
//  AccountApproveModel.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/21/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import SwiftyJSON

class AccountApproveModel: NSObject {
    
    var idImplementer: String?      //id nhân viên phê duyệt
    var userName: String?           //Tên user phê duyệt
    var departmentsName: String?    //chức danh

    init(_ json: JSON) {
        idImplementer = json["idImplementer"].string
        userName = json["userName"].string
        departmentsName = json["departmentsName"].string
    }
}
