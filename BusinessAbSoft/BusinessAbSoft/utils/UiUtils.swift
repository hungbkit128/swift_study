//
//  UiUtils.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/11/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

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
}
