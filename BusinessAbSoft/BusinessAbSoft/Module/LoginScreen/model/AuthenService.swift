//
//  AuthenService.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/10/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import SwiftyJSON

class AuthenService: APIServiceAgent {
    
    func registerRequest(companyName: String,
                        custName: String,
                        email: String,
                        isdn: String,
                        completion: @escaping((NSError?) -> Void)) {
        
        if let request = APIRequestProvider.shareInstance?.registerRequest(companyName: companyName,
                                                                           custName: custName,
                                                                           email: email,
                                                                           isdn: isdn) {
            
            self.startRequest(request) { (_ json: JSON, _ error: NSError?) in
                completion(error)
            }
        }
    }
    
    func loginRequest(username: String,
                      password: String,
                      captchaId: String?,
                      captchaString: String?,
                      completion: @escaping((UserInfoModel?, NSError?) -> Void)) {
        
        if let request = APIRequestProvider.shareInstance?.loginRequest(username: username, password: password) {
            self.startRequest(request) { (_ json: JSON, _ error: NSError?) in
                let userInfo = UserInfoModel(json["UserLogin"])
                completion(userInfo, error)
            }
        }
    }
}
