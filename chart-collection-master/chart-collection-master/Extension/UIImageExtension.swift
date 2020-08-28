//
//  UIImageExtension.swift
//  CBCT-Viettel
//
//  Created by GEM on 4/21/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

extension UIImage {

    class func imageFromBase64(_ encodedImageData: String?) -> UIImage? {
        guard encodedImageData != nil else {
            return UIImage()
        }
        let dataDecoded: Data = Data(base64Encoded: encodedImageData!, options: .ignoreUnknownCharacters)!
        let decodedImage = UIImage(data: dataDecoded)
        return decodedImage
    }

    func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }

    var flippedHorizontally: UIImage {
        return UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: .down)
    }

    func rotateImage() -> UIImage {
        return UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: .upMirrored)
    }

    static func imageFromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }

    func scaleImageWithDivisor(divisor: CGFloat) -> UIImage {
        let size = CGSize(width: self.size.width/divisor, height: self.size.height/divisor)
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }

    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
}
