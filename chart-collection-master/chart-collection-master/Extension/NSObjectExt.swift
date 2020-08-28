//
//  NSObjectExt.swift
//  chart-collection-master
//
//  Created by Tran Van Hung on 8/26/20.
//  Copyright © 2020 hba. All rights reserved.
//

import UIKit

extension NSObject {

    class func classString() -> String! {
        let str = String(describing: self)
        return str
    }
    
}
