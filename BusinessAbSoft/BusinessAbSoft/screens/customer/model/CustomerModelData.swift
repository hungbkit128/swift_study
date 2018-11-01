//
//  CustomerModelData.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/9/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class CustomerModel: Codable {
    var IdUser:String?
    var CustomerName:String?
    var CustomerCode:String?
    var CustomerId:String?
    var Address:String?
    var Email:String?
    var PhoneNumber:String?
    var Token:String?
}

class CustomerModelData: Codable {
    var ErrorCode:String?
    var Description:String?
    var LstCustomerModel:[CustomerModel]?
}
