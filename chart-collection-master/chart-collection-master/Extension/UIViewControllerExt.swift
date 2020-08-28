//
//  UIViewControllerExt.swift
//  chart-collection-master
//
//  Created by Tran Van Hung on 8/26/20.
//  Copyright © 2020 hba. All rights reserved.
//

import UIKit
import MBProgressHUD
import WYPopoverController

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    class func initWithNibTemplate<T>() -> T {
        let nibName = String(describing: self)
        let viewcontroller = self.init(nibName: nibName, bundle: Bundle.main)
        return viewcontroller as! T
    }

    func alertWithTitle(_ title: String?, message: String?) {
        if let content = message {
            if content.count > 0 {
                let alertController = UIAlertController(title: title, message: content, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func alertWithTitle(_ title: String?, message: String?, completeHandler: ((() -> Swift.Void)?) ) {
        if let content = message {
            if content.count > 0 {
                let alertController = UIAlertController(title: title, message: content, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
                    if let handler = completeHandler {
                        handler()
                    }
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func alertView(_ title: String?, message: String?) {
        if let content = message {
            if content.count > 0 {
                let alertController = UIAlertController(title: title, message: content, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func alertView(_ title: String?, message: String?, confirmHandler: (() -> Void)?, cancelHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            if let handler = confirmHandler {
                handler()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            if let handler = cancelHandler {
                handler()
            }
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func showHud() {
        hideHude()
        var loadingNotification: MBProgressHUD
        if let window = UIApplication.shared.windows.first {
            loadingNotification = MBProgressHUD.showAdded(to: window, animated: true)
        } else {
            loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        }

        loadingNotification.label.text = "He thong dang xu ly..."
        loadingNotification.label.numberOfLines = 0
        loadingNotification.backgroundView.style = .solidColor
        loadingNotification.backgroundView.color = .black
        loadingNotification.backgroundView.alpha = 0.8
    }

    func showLoginHud() {
        var loadingNotification: MBProgressHUD
        if let window = UIApplication.shared.windows.first {
            loadingNotification = MBProgressHUD.showAdded(to: window, animated: true)
        } else {
            loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        }

        loadingNotification.label.text = "He thong dang xu ly..."
        loadingNotification.label.numberOfLines = 0
        loadingNotification.backgroundView.style = .solidColor
        loadingNotification.backgroundView.color = .black
        loadingNotification.backgroundView.alpha = 0.8
    }

    func showAndGetHud() -> MBProgressHUD {
        var loadingNotification: MBProgressHUD
        if let window = UIApplication.shared.windows.first {
            loadingNotification = MBProgressHUD.showAdded(to: window, animated: true)
        } else {
            loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        }

        loadingNotification.label.text = "He thong dang xu ly..."
        loadingNotification.backgroundView.style = .solidColor
        loadingNotification.backgroundView.color = .black
        loadingNotification.backgroundView.alpha = 0.8
        return loadingNotification
    }

    func hideHude() {
        if let window = UIApplication.shared.windows.first {
            MBProgressHUD.hide(for: window, animated: true)
        } else {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }

    func hideHud(fromView targetView: UIView) {
        MBProgressHUD.hide(for: targetView, animated: true)
    }

    func showToastProcessSuccess() {
        if let windown = UIApplication.shared.windows.first {
            let hub = MBProgressHUD.showAdded(to: windown, animated: true)
            hub.label.text = "He thong dang xu ly..."
            hub.contentColor = UIColor.white
            hub.label.isEnabled = true
            hub.mode = .text
            hub.isUserInteractionEnabled = false
            hub.removeFromSuperViewOnHide = true
            hub.hide(animated: true, afterDelay: 2.0)
            hub.bezelView.backgroundColor = .blue
        }
    }

    func showToastProcessSuccess(userEnabled: Bool = false, _ completion: @escaping () -> Void) {
        if let windown = UIApplication.shared.windows.first {
            let hub = MBProgressHUD.showAdded(to: windown, animated: true)
            hub.label.text = "Done"
            hub.contentColor = UIColor.white
            hub.label.isEnabled = true
            hub.mode = .text
            hub.isUserInteractionEnabled = userEnabled
            hub.removeFromSuperViewOnHide = true
            hub.hide(animated: true, afterDelay: 2.0)
            hub.bezelView.backgroundColor = .blue
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            completion()
        }
    }

    func showToastAddNewSuccess() {
        if let windown = UIApplication.shared.windows.first {
            let hub = MBProgressHUD.showAdded(to: windown, animated: true)
            hub.label.text = "Done"
            hub.contentColor = UIColor.white
            hub.label.isEnabled = true
            hub.mode = .text
            hub.isUserInteractionEnabled = false
            hub.removeFromSuperViewOnHide = true
            hub.hide(animated: true, afterDelay: 2.0)
            hub.bezelView.backgroundColor = .blue
        }
    }

    func showToastAddNewSuccess(_ message: String) {
        if let windown = UIApplication.shared.windows.first {
            let hub = MBProgressHUD.showAdded(to: windown, animated: true)
            hub.label.text = message
            hub.contentColor = UIColor.white
            hub.label.isEnabled = true
            hub.mode = .text
            hub.isUserInteractionEnabled = false
            hub.removeFromSuperViewOnHide = true
            hub.hide(animated: true, afterDelay: 2.0)
            hub.bezelView.backgroundColor = .blue
        }
    }

    func showToast(_ message: String, _ userEnabled: Bool = false) {
        if let windown = UIApplication.shared.windows.first {
            let hub = MBProgressHUD.showAdded(to: windown, animated: true)
            hub.label.text = message
            hub.mode = .text
            hub.isUserInteractionEnabled = userEnabled
            hub.removeFromSuperViewOnHide = true
            hub.hide(animated: true, afterDelay: 2.0)
        }
    }

    func showPopoverView(popOver: WYPopoverController, frame: CGRect) {
        popOver.presentPopover(from: frame, in: self.view, permittedArrowDirections: .none, animated: true)
    }
}
