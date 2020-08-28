//
//  NewItemBlocklistDataDashboard.swift
//  CBCT-Viettel
//
//  Created by Nguyễn Việt on 6/10/19.
//  Copyright © 2019 Tung Duong Thanh. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewItemBlocklistDataDashboard: NSObject {
    

    var prdID: Double?
    var donVi: String?
    var sumTH: Int?
    var email: String?
    var deptName: String?
    var sumSlsd: Double?

    init(_ json: JSON)
    {
        prdID = json["prdId"].double
        donVi = json["donVi"].string
        sumTH = json["sumTH"].int
        email = json["email"].string
        deptName = json["deptName"].string
        sumSlsd = json["sumSlsd"].double
    }
}

//"email": null,
//"deptName": "VIETTEL HN",
//"sumSlsd": 10
