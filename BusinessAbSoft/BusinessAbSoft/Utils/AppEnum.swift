//
//  AppEnum.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/20/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit

typealias ActionBlock = () -> (Void)

enum BusinessType {
    
    case quotation
    case order
    case contract
    
    func serverValue() -> String {
        switch self {
        case .quotation:
            return "TD"
        case .order:
            return "HD"
        case .contract:
            return "DH"
        }
    }
    
    static func typeFromString(_ string: String) -> String {
        if string == "HD" {
            return "CONTRACT"
        } else if string == "DH" {
            return "ORDER"
        } else {
            return "QUOTATION"
        }
    }
}


