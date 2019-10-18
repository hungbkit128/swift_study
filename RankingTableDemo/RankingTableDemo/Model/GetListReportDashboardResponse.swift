//
//  GetListReportDashboardResponse.swift
//  CBCT-Viettel
//
//  Created by GEM on 5/26/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class GetListReportDashboardResponse: NSObject {
    
    var groupCardItemList: [GroupReportModel] = []
    var currentGroup: GroupReportModel?
    var listBlock: [ItemDashboardDataModel] = []
    var numberGroupShareToMe: Int
    var title : String?
    var subTitle : String?
    var sections :[DashboardSectionModel] = []
    
    init(_ json: JSON) {
        
        for (_, subJson) in json["groupCardItemList"] {
            let model = GroupReportModel(subJson)
            groupCardItemList.append(model)
        }
        
        let currentGroupJson = json["currentGroup"]
        currentGroup = GroupReportModel(currentGroupJson)
        title = json["title"].string
        subTitle = json["subTitle"].string
        groupService = ServiceModel(json: json["groupService"])
        for (_, subJson) in json["sections"] {
            sections.append(DashboardSectionModel(subJson))
        }
        
        let advanceSearchFilterJSon = json["advanceSearchFilter"]
        let filterdto = FilterMetadataDTO(advanceSearchFilterJSon)
        advanceSearchFilter = FilterMetadataModel(filterdto)
        advanceSearchFilter?.doUpdateGroupIdUnit(currentGroup)
        for (_, subJson) in json["listBlock"] {
            let dto = DashboardDataDetailDTO(subJson)
            if let model = ItemDashboardDataModel.dataModelFromDTO(dto) {
                listBlock.append(model)
            }
        }
        
        numberGroupShareToMe = json["numberGroupShareToMe"].intValue
        
        let cycleList: String = json["cycleAvailable"].stringValue
        if !cycleList.isEmpty {
            for item in cycleList.arrayFromStringSeperatorCommas() {
                cycleAvailable.append(FinancialCycle.typeFromServer(item))
            }
        }
    }
    
    func doUpdateCycleAndTimeDefaut() {
        let cycle = currentGroup?.cycleTDAvailable
        if cycle == "" {
            cycleAvailable = [.month]
        }else {
            let cycleList = FinancialCycle.typeFromServer((cycle?.arrayFromStringSeperatorCommas())!)
            cycleAvailable.removeAll()
            cycleAvailable = cycleList
        }
    }
    
    func updateFilterMetadate(_ filter: FilterMetadataModel) {
        self.advanceSearchFilter = filter
    }
    
    func doUpdateListBlock(_ list: [ItemDashboardDataModel]) {
        self.listBlock = list
    }
    
    func doClearListBlock() {
        self.listBlock.removeAll()
    }
    
    func getAdvanceSearchFilter() -> FilterMetadataModel?{
        self.advanceSearchFilter?.updateUnitModel(groupSerive: groupService)
        return self.advanceSearchFilter
    }
}
