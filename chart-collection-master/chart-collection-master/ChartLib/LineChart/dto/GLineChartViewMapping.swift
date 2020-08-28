//
//  GLineChartViewMapping.swift
//  CBCT-Viettel
//
//  Created by Hoang on 5/3/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import Charts

class GLineChartViewMapping: NSObject {

    class func mappingFromLineChartDTO(_ dto: LineChartDTO) -> LineChartModel {
        
        let model = LineChartModel()
        model.chartTitle = dto.chartTitle
        model.leftUnit = dto.valueUnit

        for lineDTO in dto.lines {
            let legend = LegendModel(lineDTO, LegendType.lineCircle)
            model.legends.append(legend)
        }

        var listDataSet: [LineChartDataSet] = [LineChartDataSet]()
        for item in dto.lines {
            var listDataEntry: [ChartDataEntry] = [ChartDataEntry]()
            for point in item.points {
                if let yValue = point.value {
                    let originX: Double = Double(item.points.index(of: point)!)
                    let originY: Double = Double(yValue)
                    let dateEntry: ChartDataEntry = ChartDataEntry(x: originX, y: originY, data: point)
                    listDataEntry.append(dateEntry)
                }
            }

            var title = item.title
            if item.info.count > 0 {

                if item.info.count == 1 {
                    for infor in item.info {
                        title += " (" + infor.key + " " + infor.value + ")"
                    }
                } else {

                    var listInfor: [String] = [String]()

                    for infor in item.info {

                        let desc = infor.key + " " + infor.value
                        listInfor.append(desc)
                    }

                    title += " ("
                    title += listInfor.joined(separator: ", ")
                    title +=  ")"
                }
            }

            let set: LineChartDataSet = LineChartDataSet(values: listDataEntry, label: title)
            if item.color.count > 0 {
                let color = ChartColorTemplates.colorFromString(item.color)
                set.setColor(color)
                set.setCircleColor(color)
            } else {
                let index = model.leftLines.index(of: item)!
                let color = AppColor.colorLineChartAtIndex(index: index)
                set.setColor(color)
                set.setCircleColor(color)
            }

            set.lineWidth = 1.0
            if isIphoneApp() {
                set.circleRadius = 2.0
            } else {
                set.circleRadius = 3.0
            }

            set.circleHoleRadius = 0.0
            listDataSet.append(set)
        }

        let data = LineChartData(dataSets: listDataSet)
        data.setValueFont(AppFont.fontWithStyle(style: .regular, size: 10.0))
        data.setValueTextColor(AppColor.color48())
        data.setDrawValues(false)
        model.data = data
        return model
    }

    class func getSeparatorIndex(_ lines: [ItemLineDTO]) -> [Int] {
        var result: [Int] = []
        if let firstLine = lines.first {
            for (index, item) in firstLine.points.enumerated() where item.separator {
                result.append(index)
            }
        }
        return result
    }
}
