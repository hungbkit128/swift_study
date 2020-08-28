//
//  AppMacro.swift
//  chart-collection-master
//
//  Created by Tran Van Hung on 8/26/20.
//  Copyright © 2020 hba. All rights reserved.
//

import Foundation
import UIKit

let kConstantPi = 3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481117450284102701938521105559644622948954930381964428810975665933446128475648233786783165271201909145648566923460348610454326648213393607260249141273724587006606315588174881520920962829254091715364367892590360011330530548820466521384146951941511609433057270365759591953092186117381932611793105118548074462379962749567351885752724891227938183011949

func DLog(_ message: Any,
          function: String = #function,
          file: NSString = #file,
          line: Int = #line) {

    #if DEBUG
        // debug only code
        print("\(file.lastPathComponent) - \(function)[\(line)]: \(message)")
    #else
        // release only code
    #endif
}

func isIphoneApp() -> Bool {

    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
        return true
    case .pad:
        return false

    default:
        return false
    }
}
