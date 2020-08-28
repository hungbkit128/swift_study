//
//  ChartCollectionModel.swift
//  chart-collection-master
//
//  Created by Tran Van Hung on 8/27/20.
//  Copyright © 2020 hba. All rights reserved.
//

import UIKit

class ChartCollectionModel: NSObject {
    
    var title: String? = "Chart collection view"
    fileprivate var response: GetListReportDashboardResponse?
    fileprivate var isShowTableTrend: Bool = false
    fileprivate var groupTrendType: String?
    
}

extension ChartCollectionModel: DashboardListViewModelInput {
    func doUpdateCycleAndTimeDefaut() {
        response?.doUpdateCycleAndTimeDefaut()
    }

    func doUpdateTitle(_ title: String) {
        self.title = title
    }

    func doDeleteBlock(_ blockId: String) {
        if let index = response?.listBlock.index(where: {$0.uuid == blockId}) {
            response?.listBlock.remove(at: index)
        }
    }

    func doUpdateDataSorted(_ data: [ItemDashboardDataModel]) {
        response?.listBlock = data
    }

    func doUpdateGroupTrendType(_ type: String) {
        self.groupTrendType = type
    }
}

extension ChartCollectionModel: DashboardListViewModelOutput {
    
    func getTitle() -> String? {
        return title
    }

    func getResultResponse() -> GetListReportDashboardResponse? {
        return response
    }

    func getListItem() -> [ItemDashboardDataModel] {
        guard let list = response?.listBlock else {
            return []
        }
        return list
    }

    func getShowButtonSwitchTableTrend() -> Bool {
        if let group = response?.currentGroup {
            return group.isSwitch
        }
        return false
    }

    func getGroupTrendType() -> String? {
        return self.groupTrendType
    }

    func getIsGroupTypeTableTrend() -> Bool {
        if let group = response?.currentGroup {
            if group.groupType == .tableAspect {
                return true
            }
        }
        return false
    }
}
