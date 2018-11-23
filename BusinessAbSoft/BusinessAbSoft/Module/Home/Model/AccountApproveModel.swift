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
    var isSelected:Bool = false
    

    init(_ json: JSON) {
        idImplementer = json["IdImplementer"].string
        userName = json["UserName"].string
        departmentsName = json["DepartmentsName"].string
        isSelected = false
    }
}
