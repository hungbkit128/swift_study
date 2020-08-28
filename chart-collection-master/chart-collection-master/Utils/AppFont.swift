//
//  AppFont.swift
//  chart-collection-master
//
//  Created by Tran Van Hung on 8/27/20.
//  Copyright © 2020 hba. All rights reserved.
//

import UIKit

enum AppFontStyle {
    case regular
    case italic
    case bold
    case semibold
    case medium
}

class AppFont: NSObject {
    
    class func fontWithStyle(style: AppFontStyle, size: CGFloat) -> UIFont {
        let mappedFontStyle: SFCompactTextFontStyle

        switch style {
        case .regular:
            mappedFontStyle = .regular
        case .italic:
            mappedFontStyle = .regularItalic
        case .bold:
            mappedFontStyle = .bold
        case .semibold:
            mappedFontStyle = .semibold
        case .medium :
            mappedFontStyle = .medium
        }

        return SFCompactTextFont.fontWithType(mappedFontStyle, size: size)
    }

    class func fontNameDefault() -> String {
        return "SFCompactText"
    }
}
