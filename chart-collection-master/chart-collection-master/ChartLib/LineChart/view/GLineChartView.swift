//
//  LineChartView.swift
//  CBCT-Viettel
//
//  Created by Admin on 3/29/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import Charts

class GLineChartView: UIView {

    var lineChart: GBaseLineChartView
    var lineChartModel: LineChartModel?
    let contentView: GBaseChartView

    var commentStateList = [String: Bool]()
    var keyCommentListLines = [String]()
    var dateListLines = [String]()

    fileprivate weak var _delegate: GBaseChartViewDelegate?
    weak var delegate: GBaseChartViewDelegate? {
        get {
            return _delegate
        }
        set {
            _delegate = newValue
            contentView.delegate = newValue
        }
    }

    override init(frame: CGRect) {
        lineChart = GBaseLineChartView(frame: frame)
        lineChart.legend.enabled = false
        contentView = GBaseChartView.initWithFrame(frame)
        contentView.addChartView(lineChart)

        super.init(frame: frame)
        self.addSubview(contentView)

        contentView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
            make.top.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        lineChart = GBaseLineChartView(coder: aDecoder)
        lineChart.legend.enabled = false
        contentView = GBaseChartView.initWithFrame(CGRect.zero)
        contentView.addChartView(lineChart)

        super.init(coder: aDecoder)
        self.addSubview(contentView)

        contentView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
            make.top.equalTo(self)
        }
    }

    func draw(_ model: LineChartModel?, chartDes: String, legendPosition: LegendPosition) {
        lineChartModel = model
        lineChart.keyCommentListLines = keyCommentListLines
        lineChart.dateListLines = dateListLines
        lineChart.commentStateList = commentStateList

        lineChart.drawChartWithModel(model, animation: true)

        if let legend = model?.legends {
            contentView.drawLegend(data:legend, legendPosition: legendPosition)
        } else {
            contentView.drawLegend(data:[], legendPosition: legendPosition)
        }

        var leftUnit: String? = model?.leftUnit
        if let count = model?.leftLines.count {
            if count == 0 {
                leftUnit = nil
            }
        }

        var rightUnit: String? = model?.rightUnit
        if let count = model?.rightLines.count {
            if count == 0 {
                rightUnit = nil
            }
        }

        contentView.searchItem = model?.searchItem
        contentView.setTitleDescriptionUnit(model?.chartTitle,
                                            model?.unitDescription,
                                            leftUnit,
                                            rightUnit)
    }

    func draw(_ model: LineChartModel?, legendPosition: LegendPosition) {
        draw(model, legendPosition: legendPosition, entryLabelAngle: nil)
    }

    func draw(_ model: LineChartModel?, legendPosition: LegendPosition, entryLabelAngle: CGFloat?) {
        lineChartModel = model
        lineChart.keyCommentListLines = keyCommentListLines
        lineChart.dateListLines = dateListLines
        lineChart.commentStateList = commentStateList

        if let labelAngle = entryLabelAngle {
            lineChart.entryLabelAngle = labelAngle
        }
        lineChart.drawChartWithModel(model, animation: false)
        var legends: [LegendModel] = []

        if let listLegend = model?.legends {
            legends = listLegend
        }

        contentView.searchItem = model?.searchItem
        contentView.drawLegend(data:legends, legendPosition: legendPosition)
        contentView.setTitleAndUnit(model?.chartTitle, model?.leftUnit)
    }

    func drawChartWithDescription(_ model: LineChartModel?, legendPosition: LegendPosition, entryLabelAngle: CGFloat?) {
        lineChartModel = model
        lineChart.keyCommentListLines = keyCommentListLines
        lineChart.dateListLines = dateListLines
        lineChart.commentStateList = commentStateList

        if let labelAngle = entryLabelAngle {
            lineChart.entryLabelAngle = labelAngle
        }
        lineChart.drawChartWithModel(model, animation: false)
        var legends: [LegendModel] = []

        if let listLegend = model?.legends {
            legends = listLegend
        }

        var leftUnit: String? = model?.leftUnit
        if let count = model?.leftLines.count {
            if count == 0 {
                leftUnit = nil
            }
        }

        var rightUnit: String? = model?.rightUnit
        if let count = model?.rightLines.count {
            if count == 0 {
                rightUnit = nil
            }
        }

        contentView.searchItem = model?.searchItem
        contentView.drawLegend(data:legends, legendPosition: legendPosition)
        contentView.setTitleDescriptionUnit(model?.chartTitle,
                                            model?.unitDescription,
                                            leftUnit,
                                            rightUnit)
    }

    func updateCommentStateListInSon() {
        lineChart.commentStateList = commentStateList
    }

    func removeLegend() {
        contentView.legendTableView.isHidden = true
        contentView.heightLegendTableView.constant = 0
        contentView.legendCollectionView.isHidden = true
        contentView.heightCollectionView.constant = 0
    }
}
