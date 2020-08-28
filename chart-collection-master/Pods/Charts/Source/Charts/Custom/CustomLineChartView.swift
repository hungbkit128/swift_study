//
//  CustomLineChartView.swift
//  Charts
//
//  Created by GEM on 5/24/18.
//

import Foundation
import CoreGraphics

/// Chart that draws lines, surfaces, circles, ...
open class CustomLineChartView: CustomBarLineChartViewBase, LineChartDataProvider
{
    internal override func initialize()
    {
        super.initialize()
        
        renderer = LineChartRenderer(dataProvider: self, animator: _animator, viewPortHandler: _viewPortHandler)
    }
    
    // MARK: - LineChartDataProvider
    
    open var lineData: LineChartData? { return _data as? LineChartData }
}

