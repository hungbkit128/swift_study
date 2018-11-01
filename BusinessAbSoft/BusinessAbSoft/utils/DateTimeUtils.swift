//
//  DateTimeUtils.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/11/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class DateTimeUtils {
    
    static func getDateTimeString(inputString:String, inputFormat:String, outputFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        let date = dateFormatter.date(from:inputString)
        dateFormatter.dateFormat = outputFormat
        let dateTimeString = dateFormatter.string(from:date!)
        return dateTimeString
    }
    
    static func getDateStringFromDate(date:Date, outputFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormat
        let dateString = dateFormatter.string(from:date)
        return dateString
    }
    
    static func getDateFromString(inputString:String, inputFormat:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        let date = dateFormatter.date(from:inputString)
        return date!
    }
    
}



