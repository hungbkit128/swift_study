//
//  GroupTargetModel.swift
//  CBCT-Viettel
//
//  Created by GEM on 5/24/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class GroupReportModel: NSObject {
    
    var groupId: String?
    var groupName: String?
    var orderId: String?
    var ownerId: String?
    var edit: Bool = false
    var groupType: GroupDashboardType = .unknown
    var isSwitch: Bool = false
    var isItemFullSize: Bool = false
    var clone: Bool = false
    var colorLabel: UIColor = AppColor.color48()
    var groupServiceCode: String?
    var groupServiceId: Int?
    var dashboardType: String?
    var cycleTDAvailable: String = ""
    var groupTypeKey: String?
    
    override init() {}
    
    init(_ json: JSON) {
        cycleTDAvailable    = json["cycleTDAvailable"].stringValue
        groupId             = json["groupId"].stringValue
        groupName           = json["groupName"].string
        orderId             = json["orderId"].stringValue
        ownerId             = json["ownerId"].stringValue
        edit                = json["edit"].boolValue
        groupServiceId      = json["groupServiceId"].intValue
        isSwitch            = json["switch"].boolValue
        isItemFullSize      = json["full"].boolValue
        clone               = json["clone"].boolValue
        groupServiceCode    = json["groupServiceCode"].string
        dashboardType       = json["dashboardType"].string
        groupTypeKey        = json["groupType"].string
        
        if let type = groupTypeKey {
            groupType = GroupDashboardType.typeFromServer(type)
        }
        if let colorText = json["colorLabel"].string {
            colorLabel = UIColor.hexStringToUIColor(colorText)
        }
    }

    init(groupId: String) {
        self.groupId = groupId
    }

    func toNSDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["groupId"] = groupId
        dictionary["groupName"] = groupName
        dictionary["orderId"] = orderId
        dictionary["ownerId"] = ownerId
        return dictionary
    }

    func isCanEdit() -> Bool {
        return edit
    }

    func isRanking() -> Bool {
        return groupType == .ranking
    }

    func isGroupTrend() -> Bool {
        if groupType == .tableAspect || groupType == .aspectInfo {
            return true
        }
        return false
    }

    func isUserAnalystic() -> Bool {
        return groupType == .userAnalystic
    }

    func isCanClone() -> Bool {
        return clone
    }
}
