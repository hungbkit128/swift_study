//
//  PointDTO.swift
//  CBCT-Viettel
//
//  Created by Viet Pham Duc on 2/21/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class PointDTO: NSObject {
    
    var value: Double?
    var date: String = ""
    var event: String = ""
    var viewValue: String
    var separator: Bool
    var keyComment: String?
    var titleComment: String?
    var dateValue: String?

    public init(_ json: JSON) {
        if json["value"].isNull {
            value = nil
        } else {
            value = json["value"].doubleValue
        }
        keyComment = json["keyComment"].stringValue
        dateValue = json["dateValue"].stringValue
        viewValue = json["viewValue"].stringValue
        date = json["date"].stringValue
        event = json["event"].stringValue
        separator = json["separator"].boolValue
        titleComment = json["titleComment"].stringValue
    }
}
