//
// Created by AUTHOR
// Copyright (c) YEAR AUTHOR. All rights reserved.
//

import Foundation
import UIKit

class VIPERInteractor: NSObject
{
    weak var presenter: VIPERInteractorOutput?
}

extension VIPERInteractor: VIPERInteractorInput {
    func getData() {
        var list: [ItemModel] = []
        for i in 0...10 {
            let item = ItemModel.init(i)
            list.append(item)
        }
        presenter?.didGetData(list)
    }
}
