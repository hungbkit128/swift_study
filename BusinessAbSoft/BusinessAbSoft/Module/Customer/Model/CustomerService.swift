//
//  CustomerService.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/27/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit

import SwiftyJSON

class CustomerService: APIServiceAgent {
    
    func getWarningUnMake(jobId: String,
                          jobType: String,
                          completion: @escaping((UserInfoModel?, NSError?) -> Void)) {
        
        if let request = APIRequestProvider.shareInstance?.viewDetailRequest(jobId: jobId, jobType: jobType) {
            self.startRequest(request) { (_ json: JSON, _ error: NSError?) in
                let userInfo = UserInfoModel(json["UserLogin"])
                completion(userInfo, error)
            }
        }
    }
}
