//
//  URLExtension.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/2/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import Foundation

extension URL {
    func domain() -> String {
        if let domain = self.host {
            return domain
        }
        return ""
    }
}
