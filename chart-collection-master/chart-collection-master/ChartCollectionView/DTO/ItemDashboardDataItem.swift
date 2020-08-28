//
//  ItemDashboardDataItem.swift
//  CBCT-Viettel
//
//  Created by Hoang on 4/24/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class ItemDashboardDataItem: ItemDashboardDataModel {

    var data: ItemDashboardModel?
    
    public override init(_ dto: DashboardDataDetailDTO) {
        
        let itemDTO = ItemDashboardDTO(dto.data)
        data = ItemDashboardModel(itemDTO)
        super.init(dto)
    }
}
