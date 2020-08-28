//
//  ListItemDashboardModel.swift
//  CBCT-Viettel
//
//  Created by GEM on 5/14/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListItemDashboardModel: NSObject {
    var email: String?
    var isShowRanking: Bool?
    var listBlock: [ItemDashboardDataModel] = []
    var groupId: String?
    var groupName: String?
    var isShowMap: Bool?
    var filterMetaData : FilterMetadataModel?
    var title: String?
    var subTitle: String?

//    init(_ dto: ListItemDashboardDTO) {
//        email = dto.email
//        isShowRanking = dto.isShowRanking
//        groupId = dto.groupId
//        groupName = dto.groupName
//        isShowMap = dto.isShowMap
//        filterMetaData = FilterMetadataModel(dto.filterMetaData)
//        title = dto.title
//        subTitle = dto.subTitle
//        for blockDTO in dto.listBlock {
//            if let model = ItemDashboardDataModel.dataModelFromDTO(blockDTO) {
//                listBlock.append(model)
//            }
//        }
//    }
    
    init(_ json: JSON) {
        isShowMap = json["showMap"].bool
        isShowRanking = json["ranking"].boolValue
        email = json["email"].stringValue
        groupId = json["groupId"].stringValue
        groupName = json["groupName"].stringValue
        title = json["title"].stringValue
        subTitle = json["subTitle"].stringValue
        
        let filterMetaDataDTO = FilterMetadataDTO(json["filterMetadata"])
        filterMetaData = FilterMetadataModel(filterMetaDataDTO)
        
        for (_, subJson) in json["listBlock"] {
            let dto = DashboardDataDetailDTO(subJson)
            if let model = ItemDashboardDataModel.dataModelFromDTO(dto) {
                listBlock.append(model)
            }
        }
    }
}
