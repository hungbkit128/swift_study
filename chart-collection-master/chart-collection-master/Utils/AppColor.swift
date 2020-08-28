//
//  AppColor.swift
//  chart-collection-master
//
//  Created by Tran Van Hung on 8/26/20.
//  Copyright © 2020 hba. All rights reserved.
//

import UIKit

class AppColor: NSObject {

    class func color48() -> UIColor {
        return UIColor(red: 48.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    }

    class func color241() -> UIColor {
        return UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
    }

    class func color53() -> UIColor {
        return UIColor(red: 53.0/255.0, green: 53.0/255.0, blue: 53.0/255.0, alpha: 1.0)
    }

    class func whiteFour() -> UIColor {
        return UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
    }

    class func header() -> UIColor {
        return UIColor(red: 226.0/255.0, green: 236.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    }
    
    class func coolBlue() -> UIColor {
        return UIColor.hexStringToUIColor("467ac0")
    }
    
    class func coolBlueTwo() -> UIColor {
        return UIColor(red: 87.0/255.0, green: 119.0/255.0, blue: 197.0/255.0, alpha: 1.0)
    }

    class func iceBlue() -> UIColor {
        return UIColor(red: 243.0/255.0, green: 247.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }

    class func softGreen() -> UIColor {
        return UIColor(red: 108.0/255.0, green: 211.0/255.0, blue: 125.0/255.0, alpha: 1.0)
    }

    class func deepOrange() -> UIColor {
        return UIColor(red: 222.0/255.0, green: 64.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }

    class func warmGreyTwo() -> UIColor {
        return UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0)
    }

    class func percentGreen() -> UIColor {
        return UIColor(red: 60.0/255.0, green: 168.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }

    class func percentRed() -> UIColor {
        return UIColor(red: 252.0/255.0, green: 26.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }

    class func textMenuDefault() -> UIColor {
        return UIColor(hexString: "#333333")
    }

    class func tealish() -> UIColor {
        return UIColor(red: 39.0/255.0, green: 203.0/255.0, blue: 198.0/255.0, alpha: 1.0)
    }

    class func lightOrange() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 164.0/255.0, blue: 72.0/255.0, alpha: 1.0)
    }

    class func darkMint() -> UIColor {
        return UIColor(red: 81.0/255.0, green: 209.0/255.0, blue: 133.0/255.0, alpha: 1.0)
    }

    class func dodgerBlueTwo() -> UIColor {
        return UIColor(red: 87.0/255.0, green: 140.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }

    class func tomato() -> UIColor {
        return UIColor(red: 238.0/255.0, green: 64.0/255.0, blue: 20.0/255.0, alpha: 1.0)
    }

    class func sunflowerYellow() -> UIColor {
        return UIColor(red: 246.0/255.0, green: 216.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }

    class func grayRankButton() -> UIColor {
        return UIColor(red: 123.0/255.0, green: 123.0/255.0, blue: 123.0/255.0, alpha: 1.0)
    }

    class func blackColor() -> UIColor {
        return UIColor.hexStringToUIColor("303030")
    }

    class func blackTwoColor() -> UIColor {
        return UIColor.hexStringToUIColor("313131")
    }

    class func unitChartColor() -> UIColor {
        return UIColor(red: 131.0/255.0, green: 131.0/255.0, blue: 131.0/255.0, alpha: 1.0)
    }

    class func textViewMoreColor() -> UIColor {
        return UIColor(red: 72.0/255.0, green: 84.0/255.0, blue: 101.0/255.0, alpha: 1.0)
    }

    class func btnSetupTouchIdColor() -> UIColor {
        return UIColor(red: 73.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0)
    }

    class func darkWhiteColor() -> UIColor {
        return UIColor(red: 247.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1.0)
    }

    class func errorColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0)
    }

    class func color99() -> UIColor {
        return UIColor(red: 99.0/255.0, green: 99.0/255.0, blue: 99.0/255.0, alpha: 1.0)
    }

    class func advanceTabColor() -> UIColor {
        return UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)

    }

    class func advanceTabColorHighlight() -> UIColor {
        return UIColor(red: 168/255, green: 183/255, blue: 197/255, alpha: 1.0)
    }

    class func advanceTabTextColor() -> UIColor {
        return UIColor(red: 93/255, green: 93/255, blue: 93/255, alpha: 1.0)
    }

    class func colorLineChartAtIndex(index: Int) -> UIColor {

        var colors: [UIColor]! = [UIColor]()
        colors.append(AppColor.darkMint())
        colors.append(AppColor.dodgerBlueTwo())
        colors.append(AppColor.tomato())
        colors.append(AppColor.sunflowerYellow())
        colors.append(AppColor.tealish())
        colors.append(AppColor.lightOrange())
        colors.append(AppColor.percentRed())
        colors.append(AppColor.percentGreen())

        if index >= colors.count {

            return AppColor.blackColor()
        }

        return colors[index]
    }

    class func colorPieChartAtIndex(index: Int) -> UIColor {

        var colors: [UIColor] = []
        colors.append(AppColor.tealish())
        colors.append(AppColor.lightOrange())
        colors.append(AppColor.tomato())
        colors.append(AppColor.sunflowerYellow())
        colors.append(AppColor.tealish())
        colors.append(AppColor.textMenuDefault())
        colors.append(AppColor.percentRed())
        colors.append(AppColor.percentGreen())

        if colors.indices.contains(index) {
            return colors[index]
        }

        return AppColor.blackColor()
    }

    class func colorFromHex(_ hex: String, _ alpha: CGFloat = 1.0) -> UIColor {

        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.isEmpty {
            return UIColor.gray
        }

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }

    class func colorChartGridLine() -> UIColor {
        return AppColor.colorFromHex("e6e6e6")
    }

    static let backgroundItemChartType: UIColor = {
        return UIColor(red: 210/255, green: 218/255, blue: 226/255, alpha: 1.0)
    }()

    static let backgroundItemChartTypeHighlight: UIColor = {
        return UIColor(red: 156/255, green: 171/255, blue: 192/255, alpha: 1.0)
    }()
}

let AppColorClearBlue = #colorLiteral(red: 0.2275780439, green: 0.5939790606, blue: 1, alpha: 1)
let AppColorWarmGray = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
let AppColorWhiteTwo = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
let AppColorWhitethree = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
let AppColorCoral = #colorLiteral(red: 1, green: 0.2823529412, blue: 0.2823529412, alpha: 1)
let AppColorDodgerBlue = #colorLiteral(red: 0.2705882353, green: 0.6588235294, blue: 1, alpha: 1)
let AppColorOrangeStatus = #colorLiteral(red: 1, green: 0.4274509804, blue: 0, alpha: 1)
