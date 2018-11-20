//
//  HomeService.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/14/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeService: APIServiceAgent {
    
    
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
    
    
    func viewDetailRequest(jobId: String,
                           jobType: String,
                           completion: @escaping((DetailTransModel?, NSError?) -> Void)) {
        
        if let request = APIRequestProvider.shareInstance?.viewDetailRequest(jobId: jobId, jobType: jobType) {
            self.startRequest(request) { (_ json: JSON, _ error: NSError?) in
                let userInfo = DetailTransModel(json)
                completion(userInfo, error)
            }
        }
    }
    
    //doApprove
    func doApprove(approveTypeId: String,
                   completion: @escaping((DetailTransModel?, NSError?) -> Void)) {
        
        if let request = APIRequestProvider.shareInstance?.doApprove(approveTypeId: approveTypeId) {
            self.startRequest(request) { (_ json: JSON, _ error: NSError?) in
                let userInfo = DetailTransModel(json["TransModel"])
                completion(userInfo, error)
            }
        }
    }
    
    
    
}
