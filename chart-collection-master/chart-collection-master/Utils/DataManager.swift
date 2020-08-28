//
//  DataManager.swift
//  chart-collection-master
//
//  Created by Tran Van Hung on 8/28/20.
//  Copyright © 2020 hba. All rights reserved.
//

import UIKit

class DataManager: NSObject {

    static var shareInstance: DataManager = DataManager()
    
    var currencyUnit: TypeCompressNumber {
        if let type = UserDefaults.standard.object(forKey: "CHANGE_CURRENCY") as? String {
            return TypeCompressNumber.enumFromKey(type)
        }
        return .normal
    }
}
