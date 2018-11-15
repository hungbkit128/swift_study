//
//  UiUtils.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/11/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation
import SkyFloatingLabelTextField

class UiUtils {
    
    static func showAlert(title:String, viewController:UIViewController) {
        let alert = UIAlertController(title:Strings.APP_NAME, message:title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:Strings.OK, style:.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showConfirm(title:String, viewController:UIViewController, handlerOk:((UIAlertAction) -> Swift.Void)? = nil) {
        let alertController = UIAlertController(title:Strings.APP_NAME, message:title, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Strings.CANCEL, style: .default, handler: nil)
        let okAction = UIAlertAction(title: Strings.OK, style: .default, handler:handlerOk)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func applySkyscannerThemeWithIcon(textField: SkyFloatingLabelTextFieldWithIcon) {
        self.applySkyscannerTheme(textField: textField)
        textField.iconColor = ColorManager.lightGreyColor
        textField.selectedIconColor = ColorManager.mainColor
        textField.iconFont = UIFont(name: "FontAwesome", size: 14.0)
    }
    
    static func applySkyscannerTheme(textField: SkyFloatingLabelTextField) {
        textField.tintColor = ColorManager.mainColor
        textField.textColor = ColorManager.darkGreyColor
        textField.lineColor = ColorManager.lightGreyColor
        textField.selectedTitleColor = ColorManager.mainColor
        textField.selectedLineColor = ColorManager.mainColor
        
        // Set custom fonts for the title, placeholder and textfield labels
        textField.titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        textField.placeholderFont = UIFont.systemFont(ofSize: 14.0)
        textField.font = UIFont.systemFont(ofSize: 14.0)
    }
}
