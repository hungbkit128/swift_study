//
//  StringExt.swift
//  chart-collection-master
//
//  Created by Tran Van Hung on 8/26/20.
//  Copyright © 2020 hba. All rights reserved.
//

import UIKit

extension String {
    
    var isNumeric: Bool {
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }

    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size.height
    }

    func heightOfString(font: UIFont, width: CGFloat) -> CGFloat {
        let calString = NSString(string: self)
        let textSize = calString.boundingRect(with: CGSize(width: width, height: 0),
                                              options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                              attributes: [NSAttributedString.Key.font: font],
                                              context: nil)

        return textSize.height
    }

    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        return label.frame.height
    }
    
    var getNameOfServer: String {
        let strings = self.split {$0 == ":"}.map(String.init)
        var name = ""
        let count = strings.count
        if count > 2 {
            let subStrings = strings[1].split {$0 == "."}.map(String.init)
            if let lastString = subStrings.last {
                name = lastString
            }
        }
        return name
    }

    func trim() -> String {
        let trimmedString = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString
    }

    static func suffixNumber(number: NSNumber) -> NSString {

        var num: Double = number.doubleValue

        if num == Double.infinity {
            return ""
        }

        let sign = ((num < 0) ? "-" : "" )
        num = fabs(num)

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 0
        formatter.minimumIntegerDigits = 1

        if (num < 1000.0) {
            guard let number = formatter.string(from: NSNumber(value: num)) else { return "" }
            return "\(sign)\(number)" as NSString
        }
        let exp: Int = Int(log10(num) / 3.0 ); //log10(1000));
        let units: [String] = ["K", "M", "G", "T", "P", "E"]
        if exp > units.count {
            return "+∞"
        } else {
            let roundedNum: Double = 10 * num / pow(1000.0, Double(exp)) / 10
            guard let number = formatter.string(from: NSNumber(value: roundedNum)) else { return "" }
            return "\(sign)\(number)\(units[exp-1])" as NSString
        }
    }

    static func shortStr(_ str: String, full: Bool = false, count: Int = 10) -> String {
        if !full && str.count > count {
            let index = str.index(str.startIndex, offsetBy:count)
            let shortStr = String(str[..<index]) + "..."
            return shortStr
        }
        return str
    }

    func arrayFromStringSeperatorCommas() -> [String] {
        let arrayString = self.components(separatedBy: ",")
        return arrayString
    }
    func arrayFromStringSeperatorCommas(chart : String) -> [String] {
        let arrayString = self.components(separatedBy: chart)
        return arrayString
    }

    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    func isNA() -> Bool {
        if self == "NA" {
            return true
        }

        if self == "N/A" {
            return true
        }

        return false
    }

    static func isNA(_ text: String?) -> Bool {
        if text == "NA" {
            return true
        }

        if text == "N/A" {
            return true
        }
        return false
    }

    static func randomString(length: Int) -> String {

        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }

    func sortStringAlpha() -> String {
        let result = self.sorted(by: {$0 > $1})
        return String(result)
    }

    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    static func getNotationDoubleExt(_ value: Double) -> NSString {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.positiveFormat = "0.###E+0"
        formatter.exponentSymbol = "e"
        if let scientificFormatted = formatter.string(for: value) {
            print(scientificFormatted)  // "5e+2"
            return scientificFormatted as NSString
        }
        return ""
    }

    func trimOTP() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }

    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }

    static func stringDoubleMoney(_ money: Double) -> String! {

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")

        let string = formatter.string(from: NSDecimalNumber(value: money))
        return string
    }

    static func stringPercentNumber(_ money: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")

        if let string = formatter.string(from: NSNumber(floatLiteral: money)) {
            return "\(string)%"
        } else {
            return ""
        }
    }

    func stringWithRemoveUTF8() -> String {
        let simple = folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
        let nonAlphaNumeric = CharacterSet.alphanumerics.inverted
        var str = simple.components(separatedBy: nonAlphaNumeric).joined(separator: " ")
        str = str.replacingOccurrences(of: "Đ", with: "D")
        str = str.replacingOccurrences(of: "đ", with: "d")
        return str
    }

    static func stringFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }

    static func stringMoney(_ money: Float) -> String! {

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")

        let string = formatter.string(from: NSDecimalNumber(value: money))
        return string
    }

    static func stringPercentNumberNotOptional(_ money: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")

        if let string = formatter.string(from: NSDecimalNumber(value: money)) {
            return "\(string)%"
        } else {
            return ""
        }
    }

    func capitalizeFirst() -> String {
        if self.count > 0 {
            let firstIndex = self.index(startIndex, offsetBy: 1)
            return String(self[..<firstIndex]).capitalized + String(self[firstIndex...]).lowercased()
        }

        return self
    }

    func getDateWithFormat(_ format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let date = formatter.date(from: self) {
            return date
        } else {
            return Date(timeIntervalSince1970: 0)
        }
    }

    func getDateValue() -> Date {
        // WARNING: not working
        //        return self.getDateWithFormat(DateTimeFormat.ServerFormat.formatString())
        return Date()
    }

    /*
     *  fontFamily: html font family name
     *  fontSize: size of font
     *  textColor: text color in hexa string
     */
    func appendHtmlStyle(fontFamily: String, fontSize: Int, textColor: String, style: String = "") -> String {
        let string = "<html><head>"
            + "<style>"
            + "body { font-family: '\(fontFamily)', sans-serif; font-size:\(fontSize)px; color: \(textColor);}"
            + style
            + "</style>"
            + "</head> <body>"
            +    self
            + "</body> </html>"
        return string
    }

    var utf8Data: Data? {
        return data(using: .utf8)
    }
    
    func getFloatValue() -> Float {
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: self)
        if let numberFloatValue = number?.floatValue {
            return numberFloatValue
        }
        if let str = Float(self) {
            return str
        }
        return 0.0
    }
}
