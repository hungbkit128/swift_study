//
//  APIServiceAgent.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/2/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let responseCodeSuccess = 0
let errorCodeNoData     = 404

let statusCodeSuccess = "1"
let statusCodeFail = "0"

class APIServiceAgent: NSObject {
    
    func startRequest(_ request: DataRequest, completion: @escaping(JSON, NSError?) -> Void) {
        
        APIRequestProvider.clearCookie()
        
        #if DEBUG
            DLog(request.debugDescription)
        #endif
        
        request.validate().responseJSON { (_ response: DataResponse<Any>) in
            
            switch response.result {
                
            case .success:
                
                let json = JSON(response.result.value!)
                
                #if DEBUG
                    DLog(json.description)
                #endif
                
                let status = json["ErrorCode"].stringValue
                let message = json["Description"].stringValue
                
                if status == statusCodeSuccess {
                    completion(json as JSON, nil)
                } else {
                    let error = NSError.errorWith(code: 0, message: message)
                    completion(json, error)
                }
                break
                
            case .failure(let error as NSError):
                if error.domain == NSURLErrorDomain {
                    let connectionCode = [
                        NSURLErrorCannotConnectToHost,
                        NSURLErrorNetworkConnectionLost,
                        NSURLErrorBadURL,
                        NSURLErrorDNSLookupFailed,
                        NSURLErrorNotConnectedToInternet
                    ]
                    let cannotConnectToServerCode = [
                        NSURLErrorTimedOut
                    ]
                    if connectionCode.contains(error.code) {
                        let cleanedError = NSError(domain: "",
                                                   code: -1001,
                                                   userInfo: [NSLocalizedDescriptionKey: "Không có kết nối đến server"])
                        completion(JSON.null, cleanedError)
                    } else if cannotConnectToServerCode.contains(error.code) {
                        let cleanedError = NSError(domain: "",
                                                   code: error.code,
                                                   userInfo: [NSLocalizedDescriptionKey: "Không có kết nối đến server"])
                        completion(JSON.null, cleanedError)
                    } else {
                        completion(JSON.null, error)
                    }
                    break
                } else if error.domain == "Alamofire.AFError" && error.code == 3 {
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 404 {
                            APIRequestProvider.reset()
                            print("error: \(error.localizedDescription)")
                            let cleanedError = NSError(domain: "",
                                                       code: error.code,
                                                       userInfo: [NSLocalizedDescriptionKey: "Kết nối chập chờn"])
                            completion(JSON.null, cleanedError)
                            break
                        } else if statusCode == 500 {
                            let json = try? JSON(data: response.data!)
                            let errorCode = json!["errorCode"].stringValue
                            if errorCode == "DATA_NOT_PROCESSED_YET" || errorCode == "DATA_NOT_PROCESSED_YET_DASHBOARD" {
                                let err = NSError(domain: json!["errorMessage"].stringValue,
                                                  code: 500,
                                                  userInfo: [NSLocalizedDescriptionKey: json!["errorMessage"].stringValue,
                                                             "data": json as Any])
                                completion(JSON.null, err)
                                break
                            }
                        } else if statusCode != 401 {
                            let err = NSError(domain: "LocalizableHelper.happenError",
                                              code: 500,
                                              userInfo: [NSLocalizedDescriptionKey: "Đã có lỗi xảy ra"])
                            completion(JSON.null, err)
                            break
                        }
                    }
                }
                
                let json = try? JSON(data: response.data!)
                if json == nil {
                    completion(JSON.null, error)
                    break
                }
                
                if json!["errorCode"].stringValue == "TOKEN_EXPIRED" {
                    APIRequestProvider.reset()
                } else if json!["errorCode"].stringValue == "CAPTCHA_REQUIRE" {
                    let err = NSError(domain: json!["errorMessage"].stringValue,
                                      code: 699,
                                      userInfo: [NSLocalizedDescriptionKey: json!["errorMessage"].stringValue])
                    completion(JSON.null, err)
                } else if !json!["errorMessage"].stringValue.isEmpty {
                    let err = NSError(domain: json!["errorMessage"].stringValue,
                                      code: error.code,
                                      userInfo: [NSLocalizedDescriptionKey: json!["errorMessage"].stringValue])
                    completion(JSON.null, err)
                } else {
                    completion(JSON.null, error)
                }
                break
            default:
                break
            }
        }
    }
}
