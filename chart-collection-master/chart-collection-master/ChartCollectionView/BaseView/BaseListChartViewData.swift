//
//  ChartCollectionViewData.swift
//  CBCT-Viettel
//
//  Created by Admin on 6/26/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class BaseListChartViewData: NSObject {
    
    fileprivate var data: [DashboardSectionModel] = []
    fileprivate var legendInLine: Int = isIphoneApp() ? 1 : 2
    fileprivate var maxLegendLine: Int = isIphoneApp() ? -1 : 2
    fileprivate var numberItemInLine: Int = isIphoneApp() ? 1 : 3
    fileprivate var maxLine: Int = isIphoneApp() ? 1 : 3
    fileprivate var sectionNumber: Int = 1

    func doUpdateSectionsData(_ sections: [DashboardSectionModel]) {
        data.removeAll()
        data = sections
    }

    func doUpdateNumberItemInLine(_ number: Int) {
        numberItemInLine = number
    }

    func doRemoveItemAtIndexPath(_ indexPath: IndexPath) {
        data.remove(at: indexPath.row)
    }

    func doInsertItem(_ item: ItemDashboardDataModel, at indexPath: IndexPath) {
        let section = data[indexPath.section]
        var listBlock = section.listBlock
        listBlock.insert(item, at: indexPath.row)
    }

    func doUpdateActionMenu(_ canEdit: Bool, _ canDelete: Bool, canResize: Bool) {
        data.forEach { (section) in
            section.listBlock.enumerated().forEach({ (_, item) in
                item.addActionMenu(canEdit, canDelete, canResize: canResize)
            })
        }
    }

    func doUpdateSection(_ section: Int) {
        self.sectionNumber = data.count
    }

    func getIsNoData() -> Bool {
        return data.count > 0 ? false: true
    }

    func getNumberSection() -> Int {
        return data.count
    }

    func getNumberItemOfSection(_ section: Int) -> Int {
        let items = getDataInSection(section)
        return items.count
    }
    
    func getNewNumberItemOfSection(_ section: Int) -> Int {
        let items = getNewDataDashBoard(section)
        return items.count
    }

    func getItemAtIndexPath(_ indexPath: IndexPath) -> ItemDashboardDataModel {
        let items = getDataInSection(indexPath.section)
        return items[indexPath.row]
    }
    
    func getNewItemAtIndexPath(_ indexPath: IndexPath) -> NewBlocklistDataDashboard {
        let items = getNewDataDashBoard(indexPath.section)
        return items[indexPath.row]
    }
    
    func getNumberLegendInLine() -> Int {
        return legendInLine
    }

    func getMaxLineLegend() -> Int {
        return maxLegendLine
    }

    func getNumberItemInLine() -> Int {
        return numberItemInLine
    }

    func getMaxLine() -> Int {
        return maxLine
    }

    func getData() -> [DashboardSectionModel] {
        return data
    }
    func getDataInSection(_ section: Int) -> [ItemDashboardDataModel] {
        var results: [ItemDashboardDataModel] = []
    
        results = data[section].listBlock
        return results
    }
    
    func getNewDataDashBoard(_ section: Int) -> [NewBlocklistDataDashboard] {
        var results: [NewBlocklistDataDashboard] = []
        
        results = data[section].newDataDashBoard
        return results
    }

    func getAspectCodeInSection(_ section: Int) -> AspectCode? {
        return data[section].aspectCode
    }
    
}
