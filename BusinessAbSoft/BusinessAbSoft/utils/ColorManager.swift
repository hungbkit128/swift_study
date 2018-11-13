//
//  ColorManager.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/26/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class ColorManager {
    
    static let mainColor = UIColor(red: 22/255.0, green: 118/255.0, blue: 194/255.0, alpha: 1.0)
    
    static let barTintColor = UIColor(red: 0/255.0, green: 140/255.0, blue: 198/255.0, alpha: 1.0)
    static let redColor = UIColor(red: 0/255.0, green: 140/255.0, blue: 198/255.0, alpha: 1.0)
    static let unselectedIconColor = UIColor(red: 73/255.0, green: 8/255.0, blue: 10/255.0, alpha: 1.0)
    static let blueInstagramColor = UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0)
    
    static let lightGreyColor: UIColor = UIColor(red: 197 / 255, green: 205 / 255, blue: 205 / 255, alpha: 1.0)
    static let darkGreyColor: UIColor = UIColor(red: 52 / 255, green: 42 / 255, blue: 61 / 255, alpha: 1.0)
    static let overcastBlueColor: UIColor = UIColor(red: 0, green: 187 / 255, blue: 204 / 255, alpha: 1.0)
    
    static func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
