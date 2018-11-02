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

let baseURL = Bundle.main.infoDictionary?["APP_SERVICE_ENDPOINT_URL"] as! String
let apiVersion = Bundle.main.infoDictionary?["APP_SERVICE_ENDPOINT_VERSION"] as! String

class APIRequestProvider: NSObject {
    
    // MARK: SINGLETON
    static var shareInstance: APIRequestProvider? = APIRequestProvider()
    
    private var alamoFireManager: SessionManager
    
    private var _requestURL: String = baseURL
    var requestURL: String {
        set {
            _requestURL = requestURL
        }
        get {
            return _requestURL
        }
    }

    private var _headers: HTTPHeaders = [:]
    var headers: HTTPHeaders {
        set {
            _headers = headers
        }
        get {
            var headers: HTTPHeaders = [:]
            headers = [
                "Accept": "application/json",
                "Content-Type": "application/json;charset=UTF-8"
            ]
            return headers
        }
    }
    
    override init() {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 60
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        
        if let domain = URL(string: baseURL)?.domain() {
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
}
