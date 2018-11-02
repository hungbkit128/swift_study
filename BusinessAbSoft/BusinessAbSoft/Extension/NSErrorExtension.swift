//
//  NSErrorExtension.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/2/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import Foundation

extension NSError {
    public static func errorWith(code errorCode: Int, message errorMessage: String) -> NSError {
        return NSError.init(domain: "CBCTViettel.ios", code: errorCode, userInfo: [NSLocalizedDescriptionKey : errorMessage])
    }
}
