//
//  DoApproveObject.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 12/6/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit

class DoApproveObject: NSObject {
    
    var id: String              // loại phê duyệt
    var content: String         //nội dung phê duyệt
    var dateWarning: String     //Ngày phê duyệt dd/MM/yyyy
    var lstUser: [String]       //danh sách user phê duyệt
    var idCustomer: String      //mã khách hàng
    var type: String            //loại giao dich
    var idContract: String      //mã hợp đồng
    var idOrder: String         //mã đơn hàng
    var idQuotation: String     //mã báo giá

    override init() {
        self.id = ""
        self.content = ""
        self.dateWarning = ""
        self.lstUser = []
        self.idCustomer = ""
        self.type = ""
        self.idContract = ""
        self.idOrder = ""
        self.idQuotation = ""
    }
}
