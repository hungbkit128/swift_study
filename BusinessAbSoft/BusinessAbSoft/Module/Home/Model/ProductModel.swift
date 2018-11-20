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
    
    //aProduct: id sản phẩm
    //productCode: mã sản phẩm
    //productName: tên sản phẩm
    //quantity: số lượng
    //price: đơn giá
    //vat:
    //discount: chiết khấu
    //total: thành tiền

    var aProduct:String?
    var productCode:String?
    var productName:String?
    var quantity:String?
    var price:String?
    var vat:String?
    var discount:String?
    var total:String?
    var isCollapse: Bool = false
    
    init(_ jsonData: JSON) {
        self.aProduct = jsonData["AProduct"].string
        self.productCode = jsonData["ProductCode"].string
        self.productName = jsonData["Subject"].string
        self.quantity = jsonData["Quantity"].string
        self.vat = jsonData["Vat"].string
        self.price = jsonData["Price"].string
        self.discount = jsonData["Discount"].string
        self.total = jsonData["Total"].string
    }
}
