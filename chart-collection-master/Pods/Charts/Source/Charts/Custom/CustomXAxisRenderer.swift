//
//  CustomXAxisRenderer.swift
//  Charts
//
//  Created by GEM on 5/14/18.
//

import Foundation
import CoreGraphics

#if !os(OSX)
    import UIKit
#endif

@objc(CustomChartXAxisRenderer)
open class CustomXAxisRenderer: XAxisRenderer
{
    
    var labelList = [String]()
    
    var haveCommentList = [true, false, false, true, true, true]
    
    /// draws the x-labels on the specified y-position
    open override func drawLabels(context: CGContext, pos: CGFloat, anchor: CGPoint)
    {
        guard
            let xAxis = self.axis as? XAxis,
            let viewPortHandler = self.viewPortHandler,
            let transformer = self.transformer
            else { return }
        
        #if os(OSX)
            let paraStyle = NSParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
        #else
            let paraStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        #endif
        paraStyle.alignment = .center
        
        //label attrs moved from here
        //        let labelAttrs = [NSFontAttributeName: xAxis.labelFont,
        //            NSForegroundColorAttributeName: xAxis.labelTextColor,
        //            NSParagraphStyleAttributeName: paraStyle] as [NSAttributedStringKey : Any]
        let labelRotationAngleRadians = xAxis.labelRotationAngle * ChartUtils.Math.FDEG2RAD
        
        let centeringEnabled = xAxis.isCenterAxisLabelsEnabled
        
        let valueToPixelMatrix = transformer.valueToPixelMatrix
        
        var position = CGPoint(x: 0.0, y: 0.0)
        
        var labelMaxSize = CGSize()
        
        if xAxis.isWordWrapEnabled
        {
            labelMaxSize.width = xAxis.wordWrapWidthPercent * valueToPixelMatrix.a
        }
        
        let entries = xAxis.entries
        
        for i in stride(from: 0, to: entries.count, by: 1)
        {
            //label attrs moved to here
            var labelAttrs: [NSAttributedString.Key : Any]!
            
            for j in 0..<labelList.count {
                labelList[j] = labelList[j].trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
            }
            
            if centeringEnabled
            {
                position.x = CGFloat(xAxis.centeredEntries[i])
            }
            else
            {
                position.x = CGFloat(entries[i])
            }
            
            position.y = 0.0
            position = position.applying(valueToPixelMatrix)
            
            if viewPortHandler.isInBoundsX(position.x)
            {
                let label = xAxis.valueFormatter?.stringForValueFull(xAxis.entries[i], axis: xAxis).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased() ?? ""
                let labelCouldShort = xAxis.valueFormatter?.stringForValue(xAxis.entries[i], axis: xAxis) ?? ""
                
                if labelList.contains(label) {
                    if labelList.index(of: label)! < haveCommentList.count {
                        if haveCommentList[labelList.index(of: label)!] {
                            labelAttrs = [.font: xAxis.labelFont,
                                          .foregroundColor: UIColor.blue,
                                          .paragraphStyle: paraStyle]
                        } else {
                            labelAttrs = [.font: xAxis.labelFont,
                                          .foregroundColor: xAxis.labelTextColor,
                                          .paragraphStyle: paraStyle]
                        }
                    } else {
                        labelAttrs = [.font: xAxis.labelFont,
                                      .foregroundColor: xAxis.labelTextColor,
                                      .paragraphStyle: paraStyle]
                    }
                } else {
                    labelAttrs = [.font: xAxis.labelFont,
                                  .foregroundColor: xAxis.labelTextColor,
                                  .paragraphStyle: paraStyle]
                }
                
                let labelns = labelCouldShort as NSString
                
                if xAxis.isAvoidFirstLastClippingEnabled
                {
                    // avoid clipping of the last
                    if i == xAxis.entryCount - 1 && xAxis.entryCount > 1
                    {
                        let width = labelns.boundingRect(with: labelMaxSize, options: .usesLineFragmentOrigin, attributes: labelAttrs, context: nil).size.width
                        
                        if width > viewPortHandler.offsetRight * 2.0
                            && position.x + width > viewPortHandler.chartWidth
                        {
                            position.x -= width / 2.0
                        }
                    }
                    else if i == 0
                    { // avoid clipping of the first
                        let width = labelns.boundingRect(with: labelMaxSize, options: .usesLineFragmentOrigin, attributes: labelAttrs, context: nil).size.width
                        position.x += width / 2.0
                    }
                }
                
                drawLabel(context: context,
                          formattedLabel: labelCouldShort,
                          x: position.x,
                          y: pos,
                          attributes: labelAttrs,
                          constrainedToSize: labelMaxSize,
                          anchor: anchor,
                          angleRadians: labelRotationAngleRadians)
            }
        }
    }
}
