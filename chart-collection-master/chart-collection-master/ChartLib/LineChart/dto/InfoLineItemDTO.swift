//
//  InfoLineItemDTO.swift
//  CBCT-Viettel
//
//  Created by Viet Pham Duc on 2/21/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class InfoLineItemDTO: NSObject {
    
    var key: String = ""
    var value: String
    
    public init(_ json: JSON) {
        key = json["key"].stringValue
        value = json["value"].stringValue
    }
}
