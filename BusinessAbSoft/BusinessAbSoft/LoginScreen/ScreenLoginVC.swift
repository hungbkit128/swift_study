//
//  ScreenLoginVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/8/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SkyFloatingLabelTextField

class ScreenLoginVC: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var pwdTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var userNameTF: SkyFloatingLabelTextFieldWithIcon!
    var itemInfo = IndicatorInfo(title: "View")
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        applySkyscannerThemeWithIcon(textField: pwdTF)
        applySkyscannerThemeWithIcon(textField: userNameTF)

        pwdTF.iconText = "\u{f13e}"
        userNameTF.iconText = "\u{f007}"
    }
    
    func applySkyscannerThemeWithIcon(textField: SkyFloatingLabelTextFieldWithIcon) {
        self.applySkyscannerTheme(textField: textField)
        textField.iconColor = ColorManager.lightGreyColor
        textField.selectedIconColor = ColorManager.barTintColor
        textField.iconFont = UIFont(name: "FontAwesome", size: 14)
    }
    
    func applySkyscannerTheme(textField: SkyFloatingLabelTextField) {
        textField.tintColor = ColorManager.barTintColor
        textField.textColor = ColorManager.darkGreyColor
        textField.lineColor = ColorManager.lightGreyColor
        textField.selectedTitleColor = ColorManager.barTintColor
        textField.selectedLineColor = ColorManager.barTintColor
        
        // Set custom fonts for the title, placeholder and textfield labels
        textField.titleLabel.font = UIFont.systemFont(ofSize: 12.0)
        textField.placeholderFont = UIFont.systemFont(ofSize: 18.0)
        textField.font = UIFont.systemFont(ofSize: 18.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
