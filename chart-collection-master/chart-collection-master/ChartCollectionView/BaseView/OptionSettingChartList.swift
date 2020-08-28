//
//  OptionSettingChartList.swift
//  chart-collection-master
//
//  Created by Tran Van Hung on 8/26/20.
//  Copyright © 2020 hba. All rights reserved.
//

import UIKit

class OptionSettingChartList: NSObject {

    var showHideLegend: Bool = true
    var convertionUnit: TypeCompressNumber = .normal

    override init() {
        super.init()
        
        showHideLegend = true
        convertionUnit = .normal
    }

    func isShowHideLegendChange() -> Bool {
        let showHide = true
        if showHideLegend != showHide {
            showHideLegend = showHide
            return true
        }
        return false
    }

    func isCovertionUnitChange() -> Bool {
        let type = TypeCompressNumber.normal
        if convertionUnit != type {
            convertionUnit = type
            return true
        }
        return false
    }
}
