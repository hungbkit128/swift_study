//
//  AppMacro.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/14/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import Foundation
import UIKit

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

func setStatusBarBackgroundColor(color: UIColor) {
    guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
    
    statusBar.backgroundColor = color
}

enum DateStringStyle {
    case formatDate1
}

func StringFromDate(date: Date!, dateFormat: DateStringStyle!) -> String! {
    if date == nil {
        return ""
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    return dateFormatter.string(from: date)
}

func DateFromString(string: String!, dateFormat: DateStringStyle!) -> Date? {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    let date = dateFormatter.date(from: string)
    return date
}

func stringFromDate(date: Date!, dateFormat: DateStringStyle!) -> String! {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    return dateFormatter.string(from: date)
}

func convertIntToMoneyString(_ number: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 0
    formatter.minimumFractionDigits = 0
    formatter.locale = Locale(identifier: "en_US")
    let result = formatter.string(from: NSNumber(value: number))!
    let stringValue1 = String(result)
    let stringValue2 = stringValue1.replacingOccurrences(of: ",", with: ".")
    let stringResult3 = stringValue2.replacingOccurrences(of: "$", with: "")
    return stringResult3
}
