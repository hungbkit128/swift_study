//
//  BaseViewController.swift
//  chart-collection-master
//
//  Created by Tran Van Hung on 8/26/20.
//  Copyright © 2020 hba. All rights reserved.
//

import UIKit
import WYPopoverController

class BaseViewController: UIViewController {

    var popOverVC: WYPopoverController?
    var lastContentOffset: CGFloat = 0
    

    var hideBottomBarInIPad: Bool = false {
        didSet {
            if !isIphoneApp() && hideBottomBarInIPad {
                self.edgesForExtendedLayout = UIRectEdge.bottom
                self.extendedLayoutIncludesOpaqueBars = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @objc class dynamic func initWithNib() -> Self {

        let bundle = Bundle.main
        let fileManege = FileManager.default
        let nibName = String(describing: self)
        if let pathXib = bundle.path(forResource: nibName, ofType: "xib") {
            if fileManege.fileExists(atPath: pathXib) {
                return initWithNibTemplate()
            }
        }

        if let pathStoryboard = bundle.path(forResource: nibName, ofType: "storyboardc") {
            if fileManege.fileExists(atPath: pathStoryboard) {
                return initWithDefautlStoryboard()
            }
        }
        return initWithNibTemplate()
    }

    class func initWithDefautlStoryboard() -> Self {
        let className = String(describing: self)
        return instantiateFromStoryboardHelper(storyboardName: className, storyboardId: className)
    }

    class func initDefautlStoryboardWithStoryboardID(_ identifier: String!) -> Self {
        let className = String(describing: self)
        return instantiateFromStoryboardHelper(storyboardName: className, storyboardId: identifier)
    }

    class func initWithStoryboard(name: String, identifier: String) -> Self {
        return instantiateFromStoryboardHelper(storyboardName: name, storyboardId: identifier)
    }

    class func initDefaultStoryboardIdWithStoryboardName(name: String) -> Self {
        let className = String(describing: self)
        return instantiateFromStoryboardHelper(storyboardName: name, storyboardId: className)
    }

    private class func instantiateFromStoryboardHelper<T>(storyboardName: String, storyboardId: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        return controller
    }

    func popOverArrowStyle() -> WYPopoverArrowDirection {
        if isIphoneApp() {
            return WYPopoverArrowDirection.up
        }
        return WYPopoverArrowDirection.any
    }

    func presentPopOverVC(viewController: UIViewController!, sender: UIView?, dismissOnTap: Bool) {

        if let popOver = self.popOverVC {
            if popOver.isPopoverVisible {
                popOver.dismissPopover(animated: true, options: WYPopoverAnimationOptions.fade, completion: {
                    self.popOverVC?.delegate = nil
                    self.popOverVC = nil
                })

            } else {
                self.popOverVC?.delegate = nil
                self.popOverVC = nil

                self.popOverVC = WYPopoverController(contentViewController: viewController)
                self.popOverVC?.delegate = self
                self.popOverVC?.popoverLayoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                self.popOverVC?.wantsDefaultContentAppearance = !dismissOnTap

                if let button = sender {

                    self.popOverVC?.presentPopover(from: button.bounds,
                                                   in: button,
                                                   permittedArrowDirections: self.popOverArrowStyle(),
                                                   animated: true)

                } else {
                    self.popOverVC?.presentPopoverAsDialog(animated: true)
                }
            }

        } else {
            self.popOverVC = WYPopoverController(contentViewController: viewController)
            self.popOverVC?.delegate = self
            self.popOverVC?.popoverLayoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            self.popOverVC?.wantsDefaultContentAppearance = !dismissOnTap

            if let button = sender {
                self.popOverVC?.presentPopover(from: button.bounds,
                                               in: button,
                                               permittedArrowDirections: self.popOverArrowStyle(),
                                               animated: true)
            } else {
                self.popOverVC?.presentPopoverAsDialog(animated: true)
            }
        }
    }

    func presentPopOverVC(viewController: UIViewController!, sender: UIView?, style: WYPopoverArrowDirection) {
        if let popOver = self.popOverVC {
            if popOver.isPopoverVisible {
                popOver.dismissPopover(animated: true, options: WYPopoverAnimationOptions.fade, completion: {
                    self.popOverVC?.delegate = nil
                    self.popOverVC = nil
                })
            } else {
                self.popOverVC?.delegate = nil
                self.popOverVC = nil

                self.popOverVC = WYPopoverController(contentViewController: viewController)
                self.popOverVC?.delegate = self
                self.popOverVC?.popoverLayoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                self.popOverVC?.wantsDefaultContentAppearance = false

                if let button = sender {

                    self.popOverVC?.presentPopover(from: button.bounds,
                                                   in: button,
                                                   permittedArrowDirections: style,
                                                   animated: true)

                } else {
                    self.popOverVC?.presentPopoverAsDialog(animated: true)
                }
            }
        } else {
            self.popOverVC = WYPopoverController(contentViewController: viewController)
            self.popOverVC?.delegate = self
            self.popOverVC?.popoverLayoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            self.popOverVC?.wantsDefaultContentAppearance = false

            if let button = sender {
                self.popOverVC?.presentPopover(from: button.bounds,
                                               in: button,
                                               permittedArrowDirections: self.popOverArrowStyle(),
                                               animated: true)
            } else {
                self.popOverVC?.presentPopoverAsDialog(animated: true)
            }
        }
    }

    func presentPopOverVC(viewController: UIViewController!, sender: UIView?, complete:(() -> Swift.Void)?) {

        if let popOver = self.popOverVC {
            
            if popOver
                .isPopoverVisible {
                popOver
                    .dismissPopover(animated: true,
                                    options: WYPopoverAnimationOptions.fade, completion: {
                                        self.popOverVC?.delegate = nil
                                        self.popOverVC = nil
                    })
            } else {
                self.popOverVC?.delegate = nil
                self.popOverVC = nil
                self.popOverVC = WYPopoverController(contentViewController: viewController)
                self.popOverVC?.delegate = self
                self.popOverVC?.popoverLayoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                self.popOverVC?.wantsDefaultContentAppearance = false
                if let button = sender {
                    self.popOverVC?.presentPopover(from: button.bounds,
                                        in: button,
                                        permittedArrowDirections: self.popOverArrowStyle(),
                                        animated: true,
                                        options: WYPopoverAnimationOptions.fade,
                                        completion: {
                                            if let done = complete {
                                                done()
                                            }
                        })
                } else {
                    self.popOverVC?.presentPopoverAsDialog(animated: true, options: WYPopoverAnimationOptions.fade, completion: {
                        if let done = complete {
                            done()
                        }
                    })
                }
            }
        } else {
            self.popOverVC = WYPopoverController(contentViewController: viewController)
            self.popOverVC?.delegate = self
            self.popOverVC?.popoverLayoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            self.popOverVC?.wantsDefaultContentAppearance = false
            if let button = sender {
                self.popOverVC?
                    .presentPopover(from: button.bounds,
                                    in: button,
                                    permittedArrowDirections: self.popOverArrowStyle(),
                                    animated: true,
                                    options: WYPopoverAnimationOptions.fade,
                                    completion: {
                                        if let done = complete {
                                            done()
                                        }
                })
            } else {
                self.popOverVC?
                    .presentPopoverAsDialog(animated: true, options: WYPopoverAnimationOptions.fade, completion: {
                    if let done = complete {
                        done()
                    }
                })
            }
        }
    }

    func presentPopOverVCByDirection(viewController: UIViewController!, sender: UIView?, style: WYPopoverArrowDirection) {

        self.popOverVC = WYPopoverController(contentViewController: viewController)
        self.popOverVC?.delegate = self
        self.popOverVC?.popoverLayoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.popOverVC?.wantsDefaultContentAppearance = false
        
        if let button = sender {
            self.popOverVC?.presentPopover(from: button.bounds,
                                           in: button,
                                           permittedArrowDirections: style,
                                           animated: true)
        } else {
            self.popOverVC?.presentPopoverAsDialog(animated: true)
        }
    }

    func dismissPopOver() {
        if let popOver = self.popOverVC {
            if popOver.isPopoverVisible {
                popOver.dismissPopover(animated: true, options: WYPopoverAnimationOptions.fade, completion: {
                    self.popOverVC?.delegate = nil
                    self.popOverVC = nil
                })

            } else {
                self.popOverVC?.delegate = nil
                self.popOverVC = nil
            }
        }
    }

    func dismissPopOver(complete:(() -> Swift.Void)?) {
        if let popOver = self.popOverVC {
            if popOver.isPopoverVisible {

                popOver.dismissPopover(animated: true, options: WYPopoverAnimationOptions.fade, completion: {
                    self.popOverVC?.delegate = nil
                    self.popOverVC = nil

                    if let done = complete {
                        done()
                    }
                })

            } else {
                self.popOverVC?.delegate = nil
                self.popOverVC = nil

                if let done = complete {
                    done()
                }
            }
        }
    }
}

extension BaseViewController: WYPopoverControllerDelegate {
    func popoverControllerDidDismissPopover(_ popoverController: WYPopoverController!) {
        self.popOverVC?.delegate = nil
        self.popOverVC = nil
    }
}
