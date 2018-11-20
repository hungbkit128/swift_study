//
//  ProductViewModel.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/20/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit

class ProductViewModel: NSObject {

    var listProduct: [ProductModel] = []
    
    func setListProduct(_ list: [ProductModel]) {
        self.listProduct = list
    }
    
    func getNumberSection() -> Int {
        return self.listProduct.count
    }
    
    func getProductWithSection(_ section: Int) -> ProductModel {
        return self.listProduct[section]
    }
    
    func updateCollapse(_ index: Int) {
        self.listProduct[index].isCollapse = !self.listProduct[index].isCollapse
    }
}
