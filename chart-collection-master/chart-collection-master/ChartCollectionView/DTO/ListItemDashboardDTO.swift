//
//  ListItemDashboardDTO.swift
//  CBCT-Viettel
//
//  Created by GEM on 5/14/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListItemDashboardDTO: NSObject {
    var email: String?
    var isShowRanking: Bool?
    var groupId: String?
    var groupName: String?
    var isShowMap: Bool?
    var filterMetaData: FilterMetadataDTO?
    var listBlock: [DashboardDataDetailDTO] = []
    var title: String?
    var subTitle: String?

    public init(_ json: JSON) {
        isShowMap = json["showMap"].bool
        isShowRanking = json["ranking"].boolValue
        email = json["email"].stringValue
        groupId = json["groupId"].stringValue
        groupName = json["groupName"].stringValue
        title = json["title"].stringValue
        subTitle = json["subTitle"].stringValue
        filterMetaData = FilterMetadataDTO(json["filterMetadata"])
        for (_, subJson) in json["listBlock"] {
            let dto = DashboardDataDetailDTO(subJson)
            listBlock.append(dto)
        }
    }
}
