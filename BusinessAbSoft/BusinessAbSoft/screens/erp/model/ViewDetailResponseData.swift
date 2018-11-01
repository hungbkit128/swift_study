//
//  ViewDetailResponseData.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/22/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class TransModel: Codable {
    var Id:String?
    var Code:String?
    var Title:String?
    var Subject:String?
    var Note:String?
    var CreateDate:String?
    var ImplementerName:String?
    var TypeName:String?
    var ACustomer:String?
    var CustomerName:String?
    var ImplementName:String?
}

class ProductModel: Codable {
    var AProduct:String?
    var ProductCode:String?
    var ProductName:String?
    var Quantity:String?
    var Price:String?
    var Vat:String?
    var Discount:String?
    var Total:String?
}

class AttackFileModel: Codable {
    var AAttackFile:String?
    var FileName:String?
    var FileContent:String?
}

class ViewDetailResponseData: Codable {
    var ErrorCode:String?
    var Description:String?
    
    var TransModel:TransModel?
    var LstProductModel:[ProductModel]?
    var LstAttackFileModel:[AttackFileModel]?
}
