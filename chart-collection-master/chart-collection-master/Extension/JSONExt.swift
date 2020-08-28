//
//  JSONExt.swift
//  chart-collection-master
//
//  Created by Tran Van Hung on 8/27/20.
//  Copyright © 2020 hba. All rights reserved.
//

import UIKit
import SwiftyJSON


extension JSON {
    public var isNull: Bool {
        get {
            return self.type == .null
        }
    }
}
