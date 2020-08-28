//
//  GEMLineChartView.swift
//  VT
//
//  Created by Hoang on 2/20/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit
import Charts

protocol GBaseLineChartViewDelegate: class {
    func navigateCommentLineChart(sender: Any,
                                         _ location: CGPoint,
                                         _ comments: [CommentDTO],
                                         _ listObjectCmt: [[ObjectComment]],
                                         _ chartEntry: SingleModelComment,
                                         _ cycleTime: String)
    func didShowHoverViewWithData(chart: GBaseLineChartView, data: [EntryDataModel])
    func reloadDataLine(indexPath: IndexPath)
    func callApiFromLineChart(commentDataDTO: CommentDataDTO, cycleTime: String,
                              completion: @escaping ([CommentItem]?, Error?) -> Void)
}

extension GBaseLineChartView :CommentFullScreenPopupViewControllerDelegate {
    func updateChartData(newComment: CommentItem) {
        if let comments = self.chartData?.commentData?.comments {
            var isContain = false
            for (index, comment) in comments.enumerated() where comment.keyComment == newComment.keyComment {
                if newComment.comments.count > 0 {
                    self.chartData?.commentData?.comments[index] = newComment
                } else {
                    self.chartData?.commentData?.comments.remove(at: index)
                }
                isContain = true
                break
            }
            if !isContain {
                self.chartData?.commentData?.comments.append(newComment)
            }
        } else {
                self.chartData?.commentData?.comments.append(newComment)
        }
        if let index = indexPath {
            self.hoverDelegate?.reloadDataLine(indexPath: index)
        }
    }

    func showKeyComment() {
        DLog("ShowKey : @@@")
        if let commment = chartData?.commentData?.comments {
            for value in commment {
                DLog(value.keyComment)
            }
        }
    }
    func callApiLoadComment(controller: UIViewController,completion: @escaping (Error? ) -> Void){
        var listService = [String]()
        var listArea = [String]()
        var listDrawValue = [String]()
        
        for item in (chartData?.commentData?.listService)! {
            listService.append(item.code)
        }
        for item in (chartData?.commentData?.listArea)! {
            listArea.append(item.code)
        }
        for item in (chartData?.commentData?.listDrawValue)! {
            listDrawValue.append(item.code)
        }
        guard let listPrdId = chartData?.commentData?.listPrdId else {
            return
        }
        guard let cycleTime = chartData?.filterMetaData?.cycleTime?.serverValue() else {
            return
        }
        var groupBy = ""
        if let groupText = chartData?.commentData?.groupBy {
            groupBy = groupText
        }
        controller.showHud()
        services.getReplyComments(listServices: listService,
                                  listArea: listArea,
                                  listDrawValue: listDrawValue,
                                  listPrdId: listPrdId,
                                  cycleTime: cycleTime,
                                  groupBy: groupBy) { (response, error) in
                                    
            if let response = response {
                controller.hideHude()
                self.setResponse(response)
                completion(nil)
            } else {
                controller.hideHude()
                if let err = error {
                    if err.code == 3 {
                        controller.alertView(LocalizableHelper.getTextByKey("common.notification"),
                                             message: LocalizableHelper.getTextByKey("common.error.connectServer"))
                    } else {
                        controller.alertView(LocalizableHelper.getTextByKey("common.notification"),
                                             message: err.localizedDescription)
                    }
                    completion(err)
                }
            }
        }
    }
    func callApiController(completion: @escaping (Error? ) -> Void) {
        if let data = chartData?.commentData {
            guard let cycleTime = chartData?.filterMetaData?.cycleTime?.serverValue() else {
                return
            }
            hoverDelegate?.callApiFromLineChart(commentDataDTO: data, cycleTime: cycleTime, completion: { (reponse,error) in
                if let res = reponse {
                    self.setResponse(res)
                    completion(nil)
                } else {
                    completion(error)
                }
            })
        }
    }
}

enum GesMode {
    case GesTap
    case GesHover
}

class GBaseLineChartView: CustomLineChartView, IAxisValueFormatter, IValueFormatter, ChartViewDelegate {

    var listDateString: [String]! = [String]()
    var maxxAxisCount: Int?
    var markerView: BalloonMarker?
    var hoverView: UIView?
    weak var hoverDelegate: GBaseLineChartViewDelegate?
    var indexPath: IndexPath?
    fileprivate var isHideHoverWhenStopDrag: Bool = true

    var operationQueue = OperationQueue()

    var entryLabelAngle: CGFloat {
        get {
            return self.xAxis.labelRotationAngle
        }
        set {
            self.xAxis.labelRotationAngle = newValue
        }
    }

    fileprivate var hoverViewType: ChartHoverViewType = .none
    fileprivate var tapRecognizer: UITapGestureRecognizer?
    fileprivate var longPressRecognizer: UILongPressGestureRecognizer?
    fileprivate var selectedEntry: ChartDataEntry?
    fileprivate var selectedHighlight: Highlight?
    fileprivate var chartData: LineChartModel?

    fileprivate let services: CommentService = CommentService()

    var currentEntrySelected: ChartDataEntry?

    var commentStateList = [String: Bool]()
    var keyCommentListLines = [String]()
    var dateListLines = [String]()

    var pageType: PageType?
    var isCommentMode: Bool = false
    var isHavingComment: Bool?

    var gesMode: GesMode = GesMode.GesTap

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }

    required init(coder decoder: NSCoder) {

        super.init(coder: decoder)!
        self.setUpView()
    }

    func setUpView() {

        operationQueue.maxConcurrentOperationCount = 1

        self.clipValuesToContentEnabled     = true
        self.clipsToBounds                  = true
        self.legend.enabled                 = false
        self.doubleTapToZoomEnabled         = false
        self.chartDescription?.enabled      = false

        self.leftAxis.axisRange             = 10.0
        self.leftAxis.axisMinimum           = 0
        self.leftAxis.axisMaximum           = 100
        self.leftAxis.spaceTop              = 100.0
        self.leftAxis.drawGridLinesEnabled  = true
        self.leftAxis.labelTextColor        = AppColor.color48()
        self.leftAxis.labelFont             = AppFont.fontWithStyle(style: .regular, size: 10.0)
        self.leftAxis.gridColor             = AppColor.colorChartGridLine()
        self.leftAxis.labelCount            = 4
        self.leftAxis.valueFormatter        = self

        self.rightAxis.axisRange             = 10.0
        self.rightAxis.axisMinimum           = 0
        self.rightAxis.axisMaximum           = 100
        self.rightAxis.spaceTop              = 100.0
        self.rightAxis.drawGridLinesEnabled  = false
        self.rightAxis.labelTextColor        = AppColor.color48()
        self.rightAxis.labelFont             = AppFont.fontWithStyle(style: .regular, size: 10.0)
        self.rightAxis.gridColor             = AppColor.colorChartGridLine()
        self.rightAxis.granularityEnabled    = true
        self.rightAxis.valueFormatter        = self

        self.xAxis.drawGridLinesEnabled     = false
        self.xAxis.enabled                  = true
        self.xAxis.labelPosition            = .bottom
        self.xAxis.labelRotationAngle       = -80
        self.xAxis.labelTextColor           = AppColor.color48()
        self.xAxis.labelFont                = AppFont.fontWithStyle(style: .regular, size: 10.0)
        self.xAxis.granularityEnabled       = true
        self.xAxis.valueFormatter           = self

        self.minOffset                      = 10.0
        self.extraBottomOffset              = 5.0
        self.extraLeftOffset                = 10.0
        self.extraRightOffset               = 10.0
        self.scaleXEnabled                  = true
        self.scaleYEnabled                  = true

        self.rightAxis.enabled              = false
        self.drawGridBackgroundEnabled      = false
        self.dragEnabled                    = true
        self.noDataText                     = LocalizableHelper.getTextByKey("common.noDataChart")
        self.noDataFont                     = AppFont.fontWithStyle(style: .regular, size: 11.0)
        self.noDataTextColor                = UIColor.lightGray
        self.delegate                       = self
        self.isExclusiveTouch = true
        if isIphoneApp() {
            markerView = BalloonMarker(color: UIColor.clear,
                                       font: AppFont.fontWithStyle(style: .regular, size: 10.0),
                                       textColor: AppColor.blackColor(),
                                       insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        } else {
            markerView = BalloonMarker(color: UIColor.clear,
                                       font: AppFont.fontWithStyle(style: .regular, size: 12.0),
                                       textColor: AppColor.blackColor(),
                                       insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
        self.marker = markerView
        self.drawMarkers = true
        self.pinchZoomEnabled = false
        if isIphoneApp() {
            if self.chartXMax > Double(self.frame.size.width) {
                self.setVisibleXRangeMaximum(10)
                self.zoom(scaleX: 2.5, scaleY: 1.0, x: 0, y: 0)
            } else {
                 self.zoom(scaleX: 1.0, scaleY: 0.0, x: 0, y: 0)
            }
        } else {
            self.zoom(scaleX: 1.0, scaleY: 0.0, x: 0, y: 0)
        }

        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureHander(sender:)))
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureHander))
        longPressRecognizer?.minimumPressDuration = 0.15
    }

    func getChartData() -> LineChartModel? {
        return chartData
    }

    func checkKeyComment(list: [(key: String, value: Bool)], keyComment: String) -> Bool {
        for sortListItem in list where sortListItem.key == keyComment {
            return true
        }
        return false
    }

    func drawChartWithModel(_ dataModel: LineChartModel?, animation: Bool, completion: (() -> Void)? = nil) {

        // using only for sort and count keyCommentList number
        var haveCommentList = [String: Bool]()
        var finalHaveCommentList = [Bool]()

        for item in keyCommentListLines {
            haveCommentList.updateValue(false, forKey: item)
            finalHaveCommentList.append(false)
        }

        let sortList = haveCommentList.sorted {
            $0.0 < $1.0
        }

        if let listCmt = dataModel?.commentData?.comments {
            for item in listCmt {
                if checkKeyComment(list: sortList, keyComment: item.keyComment) {
                    finalHaveCommentList[keyCommentListLines.index(of: item.keyComment)!] = true
                }
            }
        } else {
            DLog("comments nil")
        }

        if let dateList = dataModel?.dateListPoints {
            dateListLines = dateList
        }

        if isCommentMode {
            setHaveCommentList(list: finalHaveCommentList)
        } else {
            setHaveCommentList(list: [Bool]())
        }
        setLabelList(list: dateListLines)

        self.leftAxis.drawGridLinesEnabled  = true
        self.leftAxis.axisMaximum  = 0
        self.leftAxis.axisMinimum = 0
        self.rightAxis.axisMaximum = 0
        self.rightAxis.axisMinimum = 0
        self.rightAxis.enabled = false
        self.chartData = nil
        self.data = nil

        operationQueue.addOperation {
            self.chartData = dataModel
            //self.highlightValues(nil)

            guard let model = dataModel else {
                self.data = nil
                return
            }

            if model.leftLines.count == 0 && model.rightLines.count == 0 {
                self.data = nil
                return
            }

            self.listDateString.removeAll()
            var listDataSet: [LineChartDataSet] = [LineChartDataSet]()
            self.listDateString.append(contentsOf: model.listTitle)

            for (index, item) in model.leftLines.enumerated() {
                let data = self.generatorLineDataSet(item, model, YAxis.AxisDependency.left)
                listDataSet.append(data.set)

                if index == 0 {
                    self.leftAxis.axisMinimum = data.min
                    self.leftAxis.axisMaximum = data.max
                }

                if self.leftAxis.axisMinimum > data.min {
                    self.leftAxis.axisMinimum = data.min
                }

                if self.leftAxis.axisMaximum < data.max {
                    self.leftAxis.axisMaximum = data.max
                }
            }

            for item in model.leftAvglines {
                let set = self.generatorAVGLineDataSet(item, model, YAxis.AxisDependency.left)
                listDataSet.append(set)
                if self.leftAxis.axisMaximum < set.yMax {
                    self.leftAxis.axisMaximum = set.yMax
                }
                if self.leftAxis.axisMinimum > set.yMin {
                    self.leftAxis.axisMinimum = set.yMin
                }
            }

            // tinh toan min max
            let offset: Double = abs(self.leftAxis.axisMaximum - self.leftAxis.axisMinimum)
            if offset < 1 {
                self.leftAxis.labelCount = 3
            }
            self.leftAxis.axisMinimum -= offset*0.1
            self.leftAxis.axisMaximum += offset*0.1

            let isLeftAxisDisable = listDataSet.count == 0 ? true : false
            self.leftAxis.drawLabelsEnabled = !isLeftAxisDisable

            for item in model.rightLines {
                let data = self.generatorLineDataSet(item, model, YAxis.AxisDependency.right)
                listDataSet.append(data.set)

                if self.rightAxis.axisMinimum > data.min {
                    self.rightAxis.axisMinimum = data.min
                }

                if self.rightAxis.axisMaximum < data.max {
                    self.rightAxis.axisMaximum = data.max
                }

                self.rightAxis.enabled = true
                self.leftAxis.drawGridLinesEnabled  = false
                self.rightAxis.drawGridLinesEnabled = false
            }

            for item in model.rightAvglines {
                let set = self.generatorAVGLineDataSet(item, model, YAxis.AxisDependency.right)
                listDataSet.append(set)
            }

            if isLeftAxisDisable {
                if self.leftAxis.axisMinimum > self.rightAxis.axisMinimum {
                    self.leftAxis.axisMinimum = self.rightAxis.axisMinimum
                }

                if self.leftAxis.axisMaximum < self.rightAxis.axisMaximum {
                    self.leftAxis.axisMaximum = self.rightAxis.axisMaximum
                }
            }

            self.leftAxis.xOffset = isLeftAxisDisable ? -60.0 : 5.0

            if let maxItems = self.maxxAxisCount {
                if self.listDateString.count > maxItems {
                    self.xAxis.setLabelCount(maxItems, force: true)
                } else {
                    self.xAxis.labelCount = self.listDateString.count
                }
            } else {
                self.xAxis.labelCount = self.listDateString.count
            }

            if self.listDateString.count == 1 {
                self.xAxis.spaceMin = 1
                self.xAxis.axisMaximum = 1
            } else {
                self.xAxis.axisMinimum = 0
                self.xAxis.axisMaximum = Double(self.listDateString.count) - 0.7
            }

            let data = LineChartData(dataSets: listDataSet)
            data.setValueFont(AppFont.fontWithStyle(style: .regular, size: 10.0))
            data.setValueTextColor(AppColor.color48())
            data.setValueFormatter(self)

            for set in data.dataSets {
                set.drawValuesEnabled = false
            }

            OperationQueue.main.addOperation {
                self.data = data
                if let block = completion {
                    block()
                }
            }
        }

    }

    func generatorLineDataSet(_ item: ItemLineDTO, _ model: LineChartModel, _ dependency: YAxis.AxisDependency) -> (set: LineChartDataSet, min: Double, max: Double) {
        var minLeftAxis: Double = 0
        var maxLeftAxis: Double = 0
        var isInited: Bool = false

        var listDataEntry: [ChartDataEntry] = [ChartDataEntry]()
        let color = AppColor.colorFromHex(item.color)
        for point in item.points {
            if let yValue = point.value {
                if self.listDateString.contains(point.date) {
                    let originX: Double = Double(self.listDateString.index(of: point.date)!)
                    let originY: Double = Double(yValue)
                    let dateEntry: ChartDataEntry = ChartDataEntry(x: originX, y: originY, data: point)
                    if let icon = item.pointShapeName {
                        dateEntry.icon = UIImage(named: icon)?
                            .imageWithColor(color: color)?
                            .scaleImageWithDivisor(divisor: 4)
                    }
                    listDataEntry.append(dateEntry)

                    if !isInited {
                        maxLeftAxis = originY
                        minLeftAxis = originY
                        isInited = true
                    }

                    if originY > maxLeftAxis {
                        maxLeftAxis = originY
                    }

                    if minLeftAxis > originY {
                        minLeftAxis = originY
                    }
                }
            }
        }
        let value = item.points.map { $0.value }
                               .filter { $0 == maxLeftAxis }
        if !value.isEmpty {
            maxLeftAxis = maxLeftAxis + 20
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

        let line: LineChartDataSet = LineChartDataSet(values: listDataEntry, label: title)
        line.axisDependency = dependency

        switch dependency {
        case .right:
            line.lineDashLengths = [3]
            break
        default:
            break
        }

        if item.color.count > 0, let shape = item.pointShapeName {
            let color = ChartColorTemplates.colorFromString(item.color)
            line.setColor(color)
            line.setCircleColor(shape.isEmpty ? color : UIColor.clear)
        } else {
            let index = model.leftLines.index(of: item)!
            let color = AppColor.colorLineChartAtIndex(index: index)
            line.setColor(color)
            line.setCircleColor((item.pointShapeName?.isEmpty)! ? color : UIColor.clear)
        }

        line.lineWidth = 1.0
        if isIphoneApp() {
            line.circleRadius = 2.0
        } else {
            line.circleRadius = 3.0
        }
        line.circleHoleRadius = 0.0
        return (line, minLeftAxis, maxLeftAxis)
    }

    func generatorAVGLineDataSet(_ item: ItemLineDTO, _ model: LineChartModel, _ dependency: YAxis.AxisDependency) -> LineChartDataSet {

        var listDataEntry: [ChartDataEntry] = [ChartDataEntry]()
        for point in item.points {
            if let yValue = point.value {
                if self.listDateString.contains(point.date) {
                    let originX: Double = Double(self.listDateString.index(of: point.date)!)
                    let originY: Double = Double(yValue)
                    let dateEntry: ChartDataEntry = ChartDataEntry(x: originX, y: originY, data: point)
//                    dateEntry.icon = UIImage(named: "cmtSend")
                    listDataEntry.append(dateEntry)
                }
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

        let line: LineChartDataSet = LineChartDataSet(values: listDataEntry, label: title)
        line.axisDependency = dependency
        //line.lineDashLengths = [5]
        line.lineWidth = 1.0
        line.circleHoleRadius = 0.0
        line.circleRadius = 0.0

        if item.color.count > 0 {
            let color = ChartColorTemplates.colorFromString(item.color)
            line.setColor(color)
            line.setCircleColor(color)
        } else {
            let index = model.leftLines.index(of: item)!
            let color = AppColor.colorLineChartAtIndex(index: index)
            line.setColor(color)
            line.setCircleColor(color)
        }
        return line
    }

    func drawxAxisModeDate(fromDate: Date!, toDate: Date!) {

        self.xAxis.valueFormatter = self
    }

    func isShowHoverView(_ type: ChartHoverViewType) {

        hoverViewType = type

        if type == ChartHoverViewType.none {

            self.drawMarkers = true
            self.highlightPerTapEnabled = true
            self.highlightPerDragEnabled = true

            if let gesture = longPressRecognizer {
                self.removeGestureRecognizer(gesture)
            }

        } else if type == ChartHoverViewType.onTap {

            self.drawMarkers = false
            self.highlightPerTapEnabled = false
            self.highlightPerDragEnabled = false
            self.isHideHoverWhenStopDrag = false

            if let gesture = longPressRecognizer {
                self.addGestureRecognizer(gesture)
            }

            if let gesture = tapRecognizer {
                self.addGestureRecognizer(gesture)
            }

        } else if type == ChartHoverViewType.onLongPress {

            self.drawMarkers = true
            self.highlightPerTapEnabled = true
            self.highlightPerDragEnabled = true

            if let gesture = tapRecognizer {
                self.removeGestureRecognizer(gesture)
            }

            longPressRecognizer?.minimumPressDuration = 0.15
            if let gesture = longPressRecognizer {
                self.addGestureRecognizer(gesture)
            }
        } else if type == ChartHoverViewType.onTapAndLongPressed {

            self.drawMarkers = true
            self.highlightPerTapEnabled = true
            self.highlightPerDragEnabled = true

            if let gesture = tapRecognizer {
                self.addGestureRecognizer(gesture)
            }

            longPressRecognizer?.minimumPressDuration = 0.15
            if let gesture = longPressRecognizer {
                self.addGestureRecognizer(gesture)
            }
        }
    }

    func drawHoverViewLastGroup() {
        if self.data != nil {

        }
    }

    func drawHoverViewFirstGroup() {

    }

    // MARK: 
    // MARK: TOUCH EVENT
    override func nsuiTouchesBegan(_ touches: Set<NSUITouch>, withEvent event: NSUIEvent?) {
        super.nsuiTouchesBegan(touches, withEvent: event)
    }

    override func nsuiTouchesMoved(_ touches: Set<NSUITouch>, withEvent event: NSUIEvent?) {
        super.nsuiTouchesMoved(touches, withEvent: event)
    }

    override func nsuiTouchesEnded(_ touches: Set<NSUITouch>, withEvent event: NSUIEvent?) {
        super.nsuiTouchesEnded(touches, withEvent: event)
    }

    override func nsuiTouchesCancelled(_ touches: Set<NSUITouch>?, withEvent event: NSUIEvent?) {
        super.nsuiTouchesCancelled(touches, withEvent: event)
    }

    // MARK: 
    // MARK: DELEGATE
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if axis == self.leftAxis || axis == self.rightAxis {
            return String.suffixNumber(number: NSNumber(value: value)) as String
        }

        let index = Int(value)
        if index >= self.listDateString.count || index < 0 {
            return ""
        }
        if let cycle = self.chartData?.filterMetaData?.cycleTime, cycle == .quarter {
            return String.shortStr(self.listDateString[index], full: true)
        }
        return String.shortStr(self.listDateString[index])
    }

    func stringForValueFull(_ value: Double, axis: AxisBase?) -> String {
        if axis == self.leftAxis || axis == self.rightAxis {
            return String.suffixNumber(number: NSNumber(value: value)) as String
        }

        let index = Int(value)
        if index >= self.listDateString.count || index < 0 {
            return ""
        }
        if let cycle = self.chartData?.filterMetaData?.cycleTime, cycle == .quarter {
            return self.listDateString[index]
        }
        return self.listDateString[index]
    }

    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        return String.stringDoubleMoney(value)
    }

    func clearChartData() {

        self.data = nil
        self.moveViewToX(0)
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        self.marker?.refreshContent(entry: entry, highlight: highlight)
    }

    // Called when nothing has been selected or an "un-select" has been made.
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        hideHoverView()
    }

    // Callbacks when the chart is scaled / zoomed via pinch zoom gesture.
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        if let entry = selectedEntry, let highlight = selectedHighlight {
            drawHoverView(entry: entry, highlight: highlight, isCallDelegate: false)
        }
    }

    // Callbacks when the chart is moved / translated via drag gesture.
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        if let entry = selectedEntry, let highlight = selectedHighlight {
            drawHoverView(entry: entry, highlight: highlight, isCallDelegate: false)
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let entry = selectedEntry, let hightlight = selectedHighlight {
            drawHoverView(entry: entry, highlight: hightlight, isCallDelegate: false)
        } else {
            hideHoverView()
        }
    }
    
    func setResponse(_ response: [CommentItem]) {
        chartData?.commentData?.comments.removeAll()
        chartData?.commentData?.comments = response
        drawChartWithModel(chartData, animation: true)
    }
}

extension GBaseLineChartView {
    func navigatePresent(sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        if let hightlight = self.getHighlightByTouchPoint(point) {
            let index = Int(hightlight.x)
            let keyCmtofChart = self.chartData?.leftLines.first?.points[index].keyComment
            let titleComment = self.chartData?.leftLines.first?.points[index].titleComment
            if let listCmt = chartData?.commentData?.comments {
                var obcmt = Array<[ObjectComment]>()
                obcmt.append((chartData?.commentData?.listArea)!)
                obcmt.append((chartData?.commentData?.listService)!)
                obcmt.append((chartData?.commentData?.listDrawValue)!)
                var navigateWithCommentsStatus = false
                if let point = chartData?.leftLines.first?.points[index] {
                    let chartEntry = SingleModelComment(prdId: point.dateValue, titleComment: titleComment,
                                                        keyComment: point.keyComment,
                                                        keyAll:  chartData?.commentData?.keyAll)
                    if let cycleTime = chartData?.filterMetaData?.cycleTime?.serverValue() {
                        for item in listCmt where keyCmtofChart == item.keyComment {
                            hoverDelegate?.navigateCommentLineChart(sender: self, sender.location(in: self), item.comments, obcmt, chartEntry, cycleTime)
                            navigateWithCommentsStatus = true
                            break
                        }
                        if navigateWithCommentsStatus == false {
                            hoverDelegate?.navigateCommentLineChart(sender:self, sender.location(in: self), [CommentDTO](), obcmt, chartEntry, cycleTime)
                        }
                    }
                }

            } else {
                DLog("comments nil")
            }
        }

    }
    @objc fileprivate func tapGestureHander(sender: UITapGestureRecognizer) {
        // nếu màn được mở ra bằng cách bấm Zoom, pageType != nil
        gesMode = GesMode.GesTap

        if let pageType = pageType {
            if pageType == PageType.chartZoom {
                // in chartZoom, it also doing 2 job in comment mode
                if isCommentMode {
                    // add more comment code here
                    navigatePresent(sender: sender)
                    singleTapNormalMode(sender: sender)
                    DLog("comment mode single tap")
                } else {
                     DLog("normal mode single tap")
                    singleTapNormalMode(sender: sender)
                }
            }
        } else {

            if let commentStateValue = commentStateList[(chartData?.uuid)!] {
                if commentStateValue {
                    // add more comment code here
                    navigatePresent(sender: sender)
                    DLog("comment mode single tap")
                } else {

                }
            }
        }
        CommentPopupOverView.share.hide()
    }

    func singleTapNormalMode(sender: UITapGestureRecognizer) {

        let point = sender.location(in: self)
        if let entry = self.getEntryByTouchPoint(point: point),
            let hightlight = self.getHighlightByTouchPoint(point) {
            if currentEntrySelected == entry {
                hideHoverView()
                currentEntrySelected = nil
                hoverDelegate?.didShowHoverViewWithData(chart: self, data: [])
            } else {
                drawHoverView(entry: entry, highlight: hightlight, isCallDelegate: true)
                currentEntrySelected = entry
            }
        }
    }

    @objc fileprivate func longPressGestureHander(sender: UILongPressGestureRecognizer) {
        gesMode = GesMode.GesHover

        if sender.state == .changed || sender.state == .began {
            NotificationCenter.default.post(name: Notification.Name("longPressChartBegin"), object: nil)
            let point = sender.location(in: self)
            if let entry = self.getEntryByTouchPoint(point: point),
                let hightlight = self.getHighlightByTouchPoint(point) {
                drawHoverView(entry: entry, highlight: hightlight, isCallDelegate: true)
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            if isCommentMode {
                CommentPopupOverView.share.hide()
            }
            if isHideHoverWhenStopDrag && sender.minimumPressDuration > 0 {
                hideHoverView()
            }

            if sender.state == .ended {
                NotificationCenter.default.post(name: Notification.Name("longPressChartEnd"), object: nil)
            }
        }
    }

    fileprivate func drawHoverView(entry: ChartDataEntry, highlight: Highlight, isCallDelegate: Bool) {
        selectedEntry = entry
        selectedHighlight = highlight
        let index = Int(highlight.x)
        if let entryCount = self.data?.dataSetCount {

            if entryCount == 0 {

                return
            }

            let longestLabel = self.leftAxis.getLongestLabel()
            let leftAxisWidth = longestLabel.widthOfString(usingFont: self.leftAxis.labelFont)

            let point = self.getPosition(entry: entry, axis: .left)
            var width: CGFloat = 10.0
            var minOrinX = self.extraLeftOffset
            minOrinX += self.leftAxis.xOffset
            minOrinX += leftAxisWidth

            if point.x <= minOrinX {
                hideHoverView()
            } else {

                let orginX: CGFloat = point.x - width/2
                if (orginX + self.extraRightOffset) > self.bounds.size.width {
                    width = 0
                }

                var height: CGFloat = self.bounds.height
                height -= self.extraBottomOffset
                height -= self.extraTopOffset
                height -= self.xAxis.drawLabelsEnabled ? self.xAxis.labelRotatedHeight : 0
                height -= self.xAxis.drawLabelsEnabled ? self.xAxis.yOffset : 0
                height -= self.xAxis.drawLabelsEnabled ? 0 : 10.0

                let frame = CGRect(x: orginX, y: 0.0, width: width, height: height)

                if let view = hoverView {
                    view.frame = frame
                } else {
                    let view = UIView(frame: frame)
                    view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
                    hoverView = view
                    self.addSubview(view)
                }

                let location = CGPoint(x: point.x, y: self.bounds.origin.y)
                var listData = getEntryDataAtPoint(entry, location)

                if let pointDTO = entry.data as? PointDTO {
                    let currentDate = pointDTO.date
                    if let dataPopup = chartData?.getlistEntryDataHidden(strDate: currentDate) {
                        listData.append(contentsOf: dataPopup)
                    }
                }

                if let pageType = pageType {
                    if pageType == PageType.chartZoom {
                        if hoverViewType == ChartHoverViewType.onLongPress
                            || hoverViewType == ChartHoverViewType.onTapAndLongPressed {
                            showLegenPopOverView(location, listData)
                        }

                        if isCallDelegate {
                            hoverDelegate?.didShowHoverViewWithData(chart: self, data: listData)
                        }
                        if gesMode == GesMode.GesHover {
                            if isCommentMode {
                                let keyCmtofChart = self.chartData?.leftLines.first?.points[index].keyComment
                                let titleComment = self.chartData?.leftLines.first?.points[index].titleComment
                                if let listCmt = chartData?.commentData?.comments {
                                    var obcmt = Array<[ObjectComment]>()
                                    obcmt.append((chartData?.commentData?.listArea)!)
                                    obcmt.append((chartData?.commentData?.listService)!)
                                    obcmt.append((chartData?.commentData?.listDrawValue)!)
                                    var showCommentPopupStatus = false
                                    for item in listCmt where keyCmtofChart == item.keyComment {
                                        showCommentPopOverView(location, item.comments,
                                                               checkBigestObjectComment(listObjectcomments: obcmt),
                                                               titleComment)
                                        showCommentPopupStatus = true
                                        break
                                    }
                                    if showCommentPopupStatus == false {
                                        showCommentPopOverView(location, nil,
                                                               checkBigestObjectComment(listObjectcomments: obcmt),
                                                               titleComment)
                                    }
                                }
                                DLog("chart zoom comment mode long press")
                            }
                        }
                    }
                } else {
                    if isCommentMode {
                        let keyCmtofChart = self.chartData?.leftLines.first?.points[index].keyComment
                        let titleComment = self.chartData?.leftLines.first?.points[index].titleComment
                        if let listCmt = chartData?.commentData?.comments {
                            var obcmt = Array<[ObjectComment]>()
                            obcmt.append((chartData?.commentData?.listArea)!)
                            obcmt.append((chartData?.commentData?.listService)!)
                            obcmt.append((chartData?.commentData?.listDrawValue)!)
                            var showCommentPopupStatus = false
                            for item in listCmt where keyCmtofChart == item.keyComment {
                                    showCommentPopOverView(location, item.comments,
                                                           checkBigestObjectComment(listObjectcomments: obcmt),
                                                           titleComment)
                                    showCommentPopupStatus = true
                                    break
                            }
                            if showCommentPopupStatus == false {
                                showCommentPopOverView(location, nil,
                                                       checkBigestObjectComment(listObjectcomments: obcmt),
                                                       titleComment)
                            }
                        }
                        DLog("comment mode long press")
                    } else {
                        if hoverViewType == ChartHoverViewType.onLongPress
                            || hoverViewType == ChartHoverViewType.onTapAndLongPressed {
                            showLegenPopOverView(location, listData)
                        }
                        if isCallDelegate {
                            hoverDelegate?.didShowHoverViewWithData(chart: self, data: listData)
                        }
                        DLog("normal mode long press")
                    }
                }
            }
        } else {
           hideHoverView()
        }
    }

    fileprivate func getEntryDataAtPoint(_ entry: ChartDataEntry, _ point: CGPoint) -> [EntryDataModel] {

        let entryStruct = chartData?.getEntryDataStruct()
        let leftData = entryStruct?.left
        let rightData = entryStruct?.right

        if let pointDTO = entry.data as? PointDTO {
            leftData?.entryName = pointDTO.date.replacingOccurrences(of: "\n", with: "/")
            rightData?.entryName = pointDTO.date.replacingOccurrences(of: "\n", with: "/")
        }

        if let listDataSet = self.lineData?.dataSets.reversed() {
            for set in listDataSet {
                if set.visible {
                    var legenStyle = set.axisDependency == .left ? LegendType.lineCircle : LegendType.lineDashed
                    if let lineDataSet = set as? LineChartDataSet {
                        if lineDataSet.circleRadius == 0 {
                            if let first = lineDataSet.lineDashLengths?.first, first > 0 {
                                legenStyle = .avgLine
                            } else {
                                legenStyle = .line
                            }
                        }
                    }

                    let listEntryInSet = set.entriesForXValue(entry.x)
                    if let entryPoint = listEntryInSet.first, let color = set.colors.first, let legenTitle = set.label {
                        if let pointDTO = entryPoint.data as? PointDTO {
                            let legend = LegendModel(color.toHexString(), legenTitle, legenStyle, entryPoint.icon)
                            legend.desc = pointDTO.viewValue

                            if set.axisDependency == .left {
                                leftData?.data.append(legend)
                                leftData?.event = pointDTO.event
                            } else if set.axisDependency == .right {
                                rightData?.data.append(legend)
                                rightData?.event = pointDTO.event
                            }
                        }
                    }
                }
            }
        }
        var list: [EntryDataModel] = []
        if let data = leftData {
            list.append(data)
        }

        if let data = rightData {
            list.append(data)
        }
        return list
    }

    fileprivate func hideHoverView() {
        selectedEntry = nil
        selectedHighlight = nil
        hoverView?.removeFromSuperview()
        hoverView = nil
    }

    fileprivate func showLegenPopOverView(_ location: CGPoint, _ listData: [EntryDataModel]) {
        if let windown = UIApplication.shared.windows.first {
            ChartLegendPopOverView.share.showInLocation(location: location,
                                                        fromView: self, toView: windown,
                                                        chartTitle: self.chartData?.chartTitle,
                                                        chartDesc: listData.first?.getTitleName(),
                                                        listDataEntry: listData)
        }
    }

    func doRefreshHighLightSelected() {
        if let entry = selectedEntry, let highlight = selectedHighlight {
            self.drawHoverView(entry: entry, highlight: highlight, isCallDelegate: true)
        }
    }
}
