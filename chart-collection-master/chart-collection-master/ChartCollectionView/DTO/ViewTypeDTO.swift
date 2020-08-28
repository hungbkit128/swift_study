//
//  ViewTypeDTO.swift
//  CBCT-Viettel
//
//  Created by Admin on 5/3/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewTypeDTO: NSObject {

    var objectID: String?
    var displayValue: String?

    init(_ json: JSON?) {
        objectID = json?["objectID"].string
        if let id = objectID {
            if id.isEmpty {
                objectID = json?["objectId"].string
            }
        }
        displayValue = json?["displayValue"].string
    }
}
