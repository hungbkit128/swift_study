//
//  APIRequestProvider.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/2/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIRequestProvider: NSObject {
    
    // MARK: SINGLETON
    static var shareInstance: APIRequestProvider? = APIRequestProvider()
    
    private var alamoFireManager: SessionManager
    private var privateURL: String = "http://118.70.190.38:8686"
    private var businessURL: String = "http://118.70.190.38:8088"
    
    private var headers: HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type": "application/json;charset=UTF-8"
    ]
    
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 60
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        
        if let domain = URL(string: privateURL)?.domain() {
            let serverTrustPolicies: [String: ServerTrustPolicy] = [
                domain: .disableEvaluation
            ]
            alamoFireManager = Alamofire.SessionManager(
                configuration: configuration,
                serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
            )
        } else {
            alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        }
    }
    
    class func clearCookie() {
        let cstorage = HTTPCookieStorage.shared
        if let cookies = cstorage.cookies {
            for cookie in cookies {
                cstorage.deleteCookie(cookie)
            }
        }
    }
    
    class func reset() {
        let cstorage = HTTPCookieStorage.shared
        if let cookies = cstorage.cookies {
            for cookie in cookies {
                cstorage.deleteCookie(cookie)
            }
        }
        shareInstance = nil
        shareInstance = APIRequestProvider()
    }
    
    func loginRequest(username: String, password: String) -> DataRequest {
        let urlString = privateURL.appending("/absoft/login")
        
        var param = [String: Any]()
        param["UserName"] = username
        param["PassWord"] = password
        param["Imei"] = "D83A295E-E598-4F6E-BFE4-5C25DEFE7D8F"
        param["Model"] = "test"
        
        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: JSONEncoding.default,
                                        headers: headers)
    }
}
