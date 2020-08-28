//
//  LineChartModel.swift
//  CBCT-Viettel
//
//  Created by Admin on 3/29/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import Charts

class LineChartModel: NSObject {

    var chartTitle: String?
    var leftUnit: String?
    var leftLines: [ItemLineDTO] = []
    var hiddenLines: [ItemLineDTO] = []
    
    var rightUnit: String?
    var rightLines: [ItemLineDTO] = []
    var leftAvglines: [ItemLineDTO] = []
    var rightAvglines: [ItemLineDTO] = []
    var legends: [LegendModel] = []

    var data: LineChartData?
    var dataPopup: LineChartData?
    var listTitle: [String] = []
    var unitDescription: String?
    var showLabel: Bool = false
    var separatorIndex: [Int] = []
    var uuid: String = ""
    var sizePoints: Int?

    override init() {
        super.init()
    }

    init(_ dto: LineChartDTO) {
        
        if let firstLine = dto.lines.first, dto.lines.count>0 {
            sizePoints = firstLine.points.count
        } else {
            sizePoints = 0
        }
        
        self.chartTitle = dto.chartTitle
        self.leftUnit = dto.valueUnit
        self.leftLines = dto.lines
        self.hiddenLines = dto.hiddenLines

        for dto in leftLines.reversed() {
            let legend = LegendModel(dto, LegendType.lineCircle)
            legends.append(legend)
        }

        for dto in hiddenLines.reversed() {
            let legend = LegendModel(dto, dto.average ? LegendType.lineDashed : LegendType.lineCircle)
            legends.append(legend)
        }

        for dto in rightLines {
            let legend = LegendModel(dto, LegendType.lineDashed)
            legends.append(legend)
        }

        for line in dto.avglines {
            var icon = ""
            if let shape = line.pointShapeName {
                icon = shape
            }
            let legend = LegendModel(line.color, line.title, LegendType.avgLine, UIImage(named: icon))
            legends.append(legend)
            leftAvglines.append(line)
        }
        showLabel = dto.showLabel
        separatorIndex = GLineChartViewMapping.getSeparatorIndex(leftLines)
        super.init()
        self.fetchData(dto)
    }

    func fetchData(_ dto: LineChartDTO) {
        for item in self.leftLines {
            for point in item.points {
                if self.listTitle.contains(point.date) == false {
                    self.listTitle.append(point.date)
                }
            }
        }

        for item in self.rightLines {
            for point in item.points {
                if self.listTitle.contains(point.date) == false {
                    self.listTitle.append(point.date)
                }
            }
        }
    }

   // MARK: 
    init(combineDTO: CombineLineChartDTO) {
        
        super.init()

        self.chartTitle = combineDTO.chartTitle
        self.leftUnit = combineDTO.left?.valueUnit
        self.rightUnit = combineDTO.right?.valueUnit

        if let line = combineDTO.left?.lines {
            self.leftLines = line
        }

        if let line = combineDTO.right?.lines {
            self.rightLines = line
        }

        self.fetchLegend(leftLines)
        self.fetchLegend(rightLines)
        if let list = combineDTO.left?.avglines {
            for line in list {
                var icon = ""
                if let shape = line.pointShapeName {
                    icon = shape
                }
                let legend = LegendModel(line.color, line.title, LegendType.avgLine,
                                         UIImage(named: icon))
                legends.append(legend)
                leftAvglines.append(line)
            }
        }

        if let list = combineDTO.right?.avglines {
            for line in list {
                var icon = ""
                if let shape = line.pointShapeName {
                    icon = shape
                }
                let legend = LegendModel(line.color, line.title, LegendType.avgLine,
                                         UIImage(named: icon))
                legends.append(legend)
                rightAvglines.append(line)
            }
        }

        if let lineDTO = combineDTO.left {
            self.fetchData(lineDTO)
        }

        if let lineDTO = combineDTO.right {
            self.fetchData(lineDTO)
        }
    }

    func fetchLegend(_ lines: [ItemLineDTO]) {
        
        for dto in lines {
            let legend = LegendModel(dto, LegendType.lineCircle)
            legends.append(legend)
        }
    }

    func getEntryDataAtPoint(_ point: CGPoint) -> EntryDataModel {
        let data = EntryDataModel()
        data.entryName = ""
        //data.chartName = self.chartTitle
        data.chartName = ""
        data.unit = leftUnit
        return data
    }

    func getEntryDataDefault(isTrend: Bool = false) -> EntryDataModel? {
        let data = EntryDataModel()
        data.entryName = ""
        data.unit = self.leftUnit
        //data.chartName = self.chartTitle
        data.chartName = ""
        if isTrend {
            if let avgLine = legends.first(where: {$0.type == LegendType.lineCircle}),
                let line = legends.first(where: {$0.type == LegendType.line}) {
                data.data.append(contentsOf: [avgLine, line])
            }
        } else {
            data.data.append(contentsOf: legends)
        }
        return data
    }

    func getEntryDataStruct() -> (left: EntryDataModel?, right: EntryDataModel?) {

        var leftData: EntryDataModel?
        var rightData: EntryDataModel?

        if leftLines.count > 0 {
            leftData = EntryDataModel()
            leftData?.entryName = ""
            leftData?.unit = self.leftUnit
            leftData?.chartName = ""
        }

        if rightLines.count > 0 {
            rightData = EntryDataModel()
            rightData?.entryName = ""
            rightData?.unit = self.rightUnit
            rightData?.chartName = ""
        }

        return (leftData, rightData)
    }

    func getlistEntryDataHidden(strDate: String) -> [EntryDataModel] {
        var listData: [EntryDataModel] = []

        if hiddenLines.count > 0 {
            let data = EntryDataModel()
            data.entryName = ""
            data.unit = self.leftUnit
            data.chartName = ""

            for item in hiddenLines {
                var icon = ""
                if let shape = item.pointShapeName {
                    icon = shape
                }
                let legend = LegendModel(item.color, item.title, item.average ? .line : .lineCircle,
                                         UIImage(named: icon))
                let desc = item.points.filter { $0.date == strDate }
                if !desc.isEmpty {
                    legend.desc = desc.first?.viewValue
                }
                data.data.append(legend)
            }
            listData.append(data)
        }

        return listData
    }

    func getlistEntryDataDefault() -> [EntryDataModel] {

        var listData: [EntryDataModel] = []

        if leftLines.count > 0 {
            let data = EntryDataModel()
            data.entryName = ""
            data.unit = self.leftUnit
            data.chartName = ""
            listData.append(data)

            for item in legends {
                if item.type == .lineCircle {
                    data.data.append(item)
                }
            }

            for item in leftAvglines {
                var icon = ""
                if let shape = item.pointShapeName {
                    icon = shape
                }
                let legend = LegendModel(item.color, item.title, LegendType.line,
                                        UIImage(named: icon))
                data.data.append(legend)
            }
        }

        if rightLines.count > 0 {
            let data = EntryDataModel()
            data.entryName = ""
            data.unit = self.leftUnit
            data.chartName = ""
            listData.append(data)

            for item in legends {
                if item.type == .lineDashed {
                    data.data.append(item)
                }
            }

            for item in rightAvglines {
                var icon = ""
                if let shape = item.pointShapeName {
                    icon = shape
                }
                let legend = LegendModel(item.color, item.title, LegendType.line,
                                         UIImage(named: icon))
                data.data.append(legend)
            }
        }
        return listData
    }
}
