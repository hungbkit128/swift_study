//
// Created by AUTHOR
// Copyright (c) YEAR AUTHOR. All rights reserved.
//

import Foundation
import UIKit

class VIPERViewModel: NSObject
{
    var title: String? = "VIPERViewController"
    fileprivate var list: [ItemModel] = []
}

extension VIPERViewModel: VIPERViewModelInput {
    func updateListItem(_ list: [ItemModel]) {
        self.list = list
    }
}

extension VIPERViewModel: VIPERViewModelOutput {
    
    func getTitle() -> String? {
        return title
    }
    
    func getNumberOfSection() -> Int {
        return self.list.count
    }
    
    func getItemAtIndexPath(_ index: Int) -> ItemModel {
        return self.list[index]
    }
}
