//
//  SFCompactTextFont.swift
//  CBCT-Viettel
//
//  Created by Tung Duong Thanh on 2/21/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

enum SFCompactTextFontStyle: String {
    case bold
    case boldItalic
    case heavy
    case heavyItalic
    case light
    case lightItalic
    case medium
    case mediumItalic
    case regular
    case regularItalic
    case semibold
    case semiboldItalic
    
    func fontName() -> String {
        switch self {
        case .bold:
            return "SFCompactText-Bold"
        case .boldItalic:
            return "SFCompactText-BoldItalic"
        case .heavy:
            return "SFCompactText-Heavy"
        case .heavyItalic:
            return "SFCompactText-HeavyItalic"
        case .light:
            return "SFCompactText-Light"
        case .lightItalic:
            return "SFCompactText-LightItalic"
        case .medium:
            return "SFCompactText-Medium"
        case .mediumItalic:
            return "SFCompactText-MediumItalic"
        case .regular:
            return "SFCompactText-Regular"
        case .regularItalic:
            return "SFCompactText-Italic"
        case .semibold:
            return "SFCompactText-Semibold"
        case .semiboldItalic:
            return "SFCompactText-SemiboldItalic"
        }
    }
}

class SFCompactTextFont: UIFont {

    class func fontWithType(_ type: SFCompactTextFontStyle, size: CGFloat) -> UIFont {
        if let font = UIFont(name: type.fontName(), size: size) {
            return font
        } else {
            // default return system font
            return UIFont.systemFont(ofSize: size)
        }
    }
    
}
