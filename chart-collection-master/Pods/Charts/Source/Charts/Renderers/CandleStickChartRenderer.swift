//
//  CandleStickChartRenderer.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

#if !os(OSX)
    import UIKit
#endif


open class CandleStickChartRenderer: LineScatterCandleRadarRenderer
{
    open weak var dataProvider: CandleChartDataProvider?
    
    public init(dataProvider: CandleChartDataProvider?, animator: Animator?, viewPortHandler: ViewPortHandler?)
    {
        super.init(animator: animator, viewPortHandler: viewPortHandler)
        
        self.dataProvider = dataProvider
    }
    
    open override func drawData(context: CGContext)
    {
        guard let dataProvider = dataProvider, let candleData = dataProvider.candleData else { return }

        for set in candleData.dataSets as! [ICandleChartDataSet]
        {
            if set.isVisible
            {
                drawDataSet(context: context, dataSet: set)
            }
        }
    }
    
    fileprivate var _linePoints = [CGPoint](repeating: CGPoint(), count: 6)
    fileprivate var _shadowPoints = [CGPoint](repeating: CGPoint(), count: 4)
    fileprivate var _rangePoints = [CGPoint](repeating: CGPoint(), count: 2)
    fileprivate var _openPoints = [CGPoint](repeating: CGPoint(), count: 2)
    fileprivate var _closePoints = [CGPoint](repeating: CGPoint(), count: 2)
    fileprivate var _bodyRect = CGRect()
    fileprivate var _lineSegments = [CGPoint](repeating: CGPoint(), count: 2)
    
    open func drawDataSet(context: CGContext, dataSet: ICandleChartDataSet)
    {
        guard let
            dataProvider = dataProvider,
            let animator = animator
            else { return }

        let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
        
        let phaseY = animator.phaseY
        let barSpace = dataSet.barSpace
        let showCandleBar = dataSet.showCandleBar
        
        _xBounds.set(chart: dataProvider, dataSet: dataSet, animator: animator)
        
        context.saveGState()
        for j in stride(from: _xBounds.min, through: _xBounds.range + _xBounds.min, by: 1) {
            context.setLineWidth(dataSet.shadowWidth)
            
            // get the entry
            guard let e = dataSet.entryForIndex(j) as? CandleChartDataEntry else { continue }
            
            let xPos = e.x
            
            let open = e.open
            let close = e.close
            let high = e.high
            let low = e.low
            let middle = e.middle
            
            if showCandleBar {
                // calculate the body
                var isDrawBody = true
                if high == 0 {
                    isDrawBody = false
                }
                if isDrawBody {
                    let color = e.backgroundColor
                    
                    _bodyRect.origin.x = CGFloat(xPos) - 0.5 + barSpace
                    _bodyRect.origin.y = CGFloat(close * phaseY)
                    _bodyRect.size.width = (CGFloat(xPos) + 0.5 - barSpace) - _bodyRect.origin.x
                    _bodyRect.size.height = CGFloat(open * phaseY) - _bodyRect.origin.y
                    
                    trans.rectValueToPixel(&_bodyRect)
                    context.setFillColor(color.cgColor)
                    context.fill(_bodyRect)
                }
                
                let lineColor = e.lineColor
                
                // draw body differently for increasing and decreasing entry
                
                //                if open > close
                //                {
                //                    let color = dataSet.decreasingColor ?? dataSet.color(atIndex: j)
                //
                //                    if dataSet.isDecreasingFilled
                //                    {
                //                        context.setFillColor(color.cgColor)
                //                        context.fill(_bodyRect)
                //                    }
                //                    else
                //                    {
                //                        context.setStrokeColor(color.cgColor)
                //                        context.stroke(_bodyRect)
                //                    }
                //                }
                //                else if open < close
                //                {
                //                    let color = dataSet.increasingColor ?? dataSet.color(atIndex: j)
                //
                //                    if dataSet.isIncreasingFilled
                //                    {
                //                        context.setFillColor(color.cgColor)
                //                        context.fill(_bodyRect)
                //                    }
                //                    else
                //                    {
                //                        context.setStrokeColor(color.cgColor)
                //                        context.stroke(_bodyRect)
                //                    }
                //                }
                //                else
                //                {
                //                    let color = dataSet.neutralColor ?? dataSet.color(atIndex: j)
                //
                //                    context.setStrokeColor(color.cgColor)
                //                    context.stroke(_bodyRect)
                //                }
                
                // calculate the shadow
                
                _shadowPoints[0].x = CGFloat(xPos)
                _shadowPoints[1].x = CGFloat(xPos)
                _shadowPoints[2].x = CGFloat(xPos)
                _shadowPoints[3].x = CGFloat(xPos)
                
                if open > close
                {
                    _shadowPoints[0].y = CGFloat(high * phaseY)
                    _shadowPoints[1].y = CGFloat(open * phaseY)
                    _shadowPoints[2].y = CGFloat(low * phaseY)
                    _shadowPoints[3].y = CGFloat(close * phaseY)
                }
                else if open < close
                {
                    _shadowPoints[0].y = CGFloat(high * phaseY)
                    _shadowPoints[1].y = CGFloat(close * phaseY)
                    _shadowPoints[2].y = CGFloat(low * phaseY)
                    _shadowPoints[3].y = CGFloat(open * phaseY)
                }
                else
                {
                    _shadowPoints[0].y = CGFloat(high * phaseY)
                    _shadowPoints[1].y = CGFloat(open * phaseY)
                    _shadowPoints[2].y = CGFloat(low * phaseY)
                    _shadowPoints[3].y = _shadowPoints[1].y
                }
                
                // draw the shadows
                
                //                if dataSet.shadowColorSameAsCandle
                //                {
                //                    if open > close
                //                    {
                //                        shadowColor = dataSet.decreasingColor ?? dataSet.color(atIndex: j)
                //                    }
                //                    else if open < close
                //                    {
                //                        shadowColor = dataSet.increasingColor ?? dataSet.color(atIndex: j)
                //                    }
                //                    else
                //                    {
                //                        shadowColor = dataSet.neutralColor ?? dataSet.color(atIndex: j)
                //                    }
                //                }
                //
                //                if shadowColor === nil
                //                {
                //                    shadowColor = dataSet.shadowColor ?? dataSet.color(atIndex: j)
                //                }
                
                trans.pointValuesToPixel(&_shadowPoints)
                context.setStrokeColor(lineColor.cgColor)
                context.strokeLineSegments(between: _shadowPoints)
                
                // draw high low middle
                
                var isDrawHigh = true
                var isDrawLow = true
                let isDrawMiddle = middle == 0 ? false : true
                
                if open > close {
                    isDrawHigh = open == high ? false : true
                    isDrawLow = close == open ? false : true
                }
                else if open < close {
                    isDrawHigh = close == high ? false : true
                    isDrawLow = low == open ? false : true
                }
                else {
                    isDrawHigh = open == high ? false : true
                    isDrawLow = low == open ? false : true
                }
                
                isDrawHigh = open == 0 ? false : true
                isDrawLow = close == 0 ? false : true
                
                if isDrawHigh {
                    _linePoints[0].x = CGFloat(xPos) - 0.25 * (1.0 - 2.0 * barSpace)
                    _linePoints[1].x = CGFloat(xPos) + 0.25 * (1.0 - 2.0 * barSpace)
                    _linePoints[0].y = CGFloat(high * phaseY)
                    _linePoints[1].y = CGFloat(high * phaseY)
                }
                if isDrawLow {
                    _linePoints[4].x = CGFloat(xPos) - 0.25 * (1.0 - 2.0 * barSpace)
                    _linePoints[5].x = CGFloat(xPos) + 0.25 * (1.0 - 2.0 * barSpace)
                    _linePoints[4].y = CGFloat(low * phaseY)
                    _linePoints[5].y = CGFloat(low * phaseY)
                }
                if isDrawMiddle {
                    _linePoints[2].x = CGFloat(xPos) - 0.5 + barSpace
                    _linePoints[3].x = CGFloat(xPos) + 0.5 - barSpace
                    _linePoints[2].y = CGFloat(middle * phaseY)
                    _linePoints[3].y = CGFloat(middle * phaseY)
                }
                
                trans.pointValuesToPixel(&_linePoints)
                context.setStrokeColor(lineColor.cgColor)
                context.setLineWidth(1.5)
                context.strokeLineSegments(between: _linePoints)
                
                // draw bounds to body
                
                if isDrawMiddle {
                    _bodyRect.origin.x = CGFloat(xPos) - 0.5 + barSpace
                    _bodyRect.origin.y = CGFloat(close * phaseY)
                    _bodyRect.size.width = (CGFloat(xPos) + 0.5 - barSpace) - _bodyRect.origin.x
                    _bodyRect.size.height = CGFloat(open * phaseY) - _bodyRect.origin.y
                    
                    trans.rectValueToPixel(&_bodyRect)
                    context.setStrokeColor(lineColor.cgColor)
                    context.stroke(_bodyRect)
                }
            } else {
                _rangePoints[0].x = CGFloat(xPos)
                _rangePoints[0].y = CGFloat(high * phaseY)
                _rangePoints[1].x = CGFloat(xPos)
                _rangePoints[1].y = CGFloat(low * phaseY)

                _openPoints[0].x = CGFloat(xPos) - 0.5 + barSpace
                _openPoints[0].y = CGFloat(open * phaseY)
                _openPoints[1].x = CGFloat(xPos)
                _openPoints[1].y = CGFloat(open * phaseY)

                _closePoints[0].x = CGFloat(xPos) + 0.5 - barSpace
                _closePoints[0].y = CGFloat(close * phaseY)
                _closePoints[1].x = CGFloat(xPos)
                _closePoints[1].y = CGFloat(close * phaseY)
                
                trans.pointValuesToPixel(&_rangePoints)
                trans.pointValuesToPixel(&_openPoints)
                trans.pointValuesToPixel(&_closePoints)
                
                // draw the ranges
                var barColor: NSUIColor! = nil
                
                if open > close
                {
                    barColor = dataSet.decreasingColor ?? dataSet.color(atIndex: j)
                }
                else if open < close
                {
                    barColor = dataSet.increasingColor ?? dataSet.color(atIndex: j)
                }
                else
                {
                    barColor = dataSet.neutralColor ?? dataSet.color(atIndex: j)
                }
                
                context.setStrokeColor(barColor.cgColor)
                context.strokeLineSegments(between: _rangePoints)
                context.strokeLineSegments(between: _openPoints)
                context.strokeLineSegments(between: _closePoints)
            }
        }
        
        context.restoreGState()
    }
    
    open override func drawValues(context: CGContext)
    {
        guard
            let dataProvider = dataProvider,
            let viewPortHandler = self.viewPortHandler,
            let candleData = dataProvider.candleData,
            let animator = animator
            else { return }
        
        // if values are drawn
        if isDrawingValuesAllowed(dataProvider: dataProvider)
        {
            var dataSets = candleData.dataSets
            
            let phaseY = animator.phaseY
            
            var pt = CGPoint()
            
            for i in 0 ..< dataSets.count
            {
                guard let dataSet = dataSets[i] as? IBarLineScatterCandleBubbleChartDataSet
                    else { continue }
                
                if !shouldDrawValues(forDataSet: dataSet)
                {
                    continue
                }
                
                let valueFont = dataSet.valueFont
                
                guard let formatter = dataSet.valueFormatter else { continue }
                
                let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
                let valueToPixelMatrix = trans.valueToPixelMatrix
                
                let iconsOffset = dataSet.iconsOffset
                
                _xBounds.set(chart: dataProvider, dataSet: dataSet, animator: animator)
                
                let lineHeight = valueFont.lineHeight
                let yOffset: CGFloat = lineHeight + 5.0
                
                for j in stride(from: _xBounds.min, through: _xBounds.range + _xBounds.min, by: 1)
                {
                    guard let e = dataSet.entryForIndex(j) as? CandleChartDataEntry else { break }
                    
                    pt.x = CGFloat(e.x)
                    pt.y = CGFloat(e.high * phaseY)
                    pt = pt.applying(valueToPixelMatrix)
                    
                    if (!viewPortHandler.isInBoundsRight(pt.x))
                    {
                        break
                    }
                    
                    if (!viewPortHandler.isInBoundsLeft(pt.x) || !viewPortHandler.isInBoundsY(pt.y))
                    {
                        continue
                    }
                    
                    if dataSet.isDrawValuesEnabled
                    {
                        ChartUtils.drawText(
                            context: context,
                            text: formatter.stringForValue(
                                e.high,
                                entry: e,
                                dataSetIndex: i,
                                viewPortHandler: viewPortHandler),
                            point: CGPoint(
                                x: pt.x,
                                y: pt.y - yOffset),
                            align: .center,
                            attributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): valueFont, NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): dataSet.valueTextColorAt(j)])
                    }
                    
                    if let icon = e.icon, dataSet.isDrawIconsEnabled
                    {
                        ChartUtils.drawImage(context: context,
                                             image: icon,
                                             x: pt.x + iconsOffset.x,
                                             y: pt.y + iconsOffset.y,
                                             size: icon.size)
                    }
                }
            }
        }
    }
    
    open override func drawExtras(context: CGContext)
    {
    }
    
    open override func drawHighlighted(context: CGContext, indices: [Highlight])
    {
        guard
            let dataProvider = dataProvider,
            let candleData = dataProvider.candleData,
            let animator = animator
            else { return }
        
        context.saveGState()
        
        for high in indices
        {
            guard
                let set = candleData.getDataSetByIndex(high.dataSetIndex) as? ICandleChartDataSet,
                set.isHighlightEnabled
                else { continue }
            
            guard let e = set.entryForXValue(high.x, closestToY: high.y) as? CandleChartDataEntry else { continue }
            
            if !isInBoundsX(entry: e, dataSet: set)
            {
                continue
            }
            
            let trans = dataProvider.getTransformer(forAxis: set.axisDependency)
            
            context.setStrokeColor(set.highlightColor.cgColor)
            context.setLineWidth(set.highlightLineWidth)
            
            if set.highlightLineDashLengths != nil
            {
                context.setLineDash(phase: set.highlightLineDashPhase, lengths: set.highlightLineDashLengths!)
            }
            else
            {
                context.setLineDash(phase: 0.0, lengths: [])
            }
            
            let lowValue = e.low * Double(animator.phaseY)
            let highValue = e.high * Double(animator.phaseY)
            let y = (lowValue + highValue) / 2.0
            
            let pt = trans.pixelForValues(x: e.x, y: y)
            
            high.setDraw(pt: pt)
            
            // draw the lines
            drawHighlightLines(context: context, point: pt, set: set)
        }
        
        context.restoreGState()
    }
}