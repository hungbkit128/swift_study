//
//  ProductModel.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/20/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProductModel: NSObject {

    var aProduct:String?
    var productCode:String?
    var productName:String?
    var quantity:Int?
    var price:Int?
    var vat:Int?
    var discount:Int?
    var total:Int?
    var isCollapse: Bool = false
    
    init(_ jsonData: JSON) {
        self.aProduct = jsonData["AProduct"].string
        self.productCode = jsonData["ProductCode"].string
        self.productName = jsonData["ProductName"].string
        self.quantity = jsonData["Quantity"].int
        self.vat = jsonData["Vat"].int
        self.price = jsonData["Price"].int
        self.discount = jsonData["Discount"].int
        self.total = jsonData["Total"].int
    }
}
