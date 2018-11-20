//
//  AppExtension.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/20/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit

extension NSObject {
    class func classString() -> String! {
        let str = String(describing: self)
        return str
    }
}

extension UIView {
    
    func installShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 0)
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 2.0
    }
    
    class func nibDefault() -> UINib {
        let nibName = String(describing: self)
        let nib = UINib.init(nibName: nibName, bundle: nil)
        return nib
    }
}
