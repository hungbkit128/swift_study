//
//  StringUtils.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/11/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class StringUtils {
    
    static func isNilOrEmpty(stringInput: String) -> Bool {
        if stringInput.count == 0 {
            return true
        }
        return false
    }
    
    static func isDigitString(stringInput: String) -> Bool {
        let num = Int(stringInput)
        if num != nil {
            return true
        } else {
            return false
        }
    }
    
}
