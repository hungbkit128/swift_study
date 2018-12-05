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
    
    // register
    func registerRequest(companyName: String,
                         custName: String,
                         email: String,
                         isdn: String) -> DataRequest {
        let urlString = privateURL.appending(Constants.REGISTER_URL)
        
        var param = [String: Any]()
        param["CompanyName"] = companyName
        param["CustName"] = custName
        param["Email"] = email
        param["Isdn"] = isdn
        param["Model"] = UIDevice.current.modelName
        param["Imei"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: JSONEncoding.default,
                                        headers: headers)
    }
    
    // login
    func loginRequest(username: String, password: String) -> DataRequest {
        let urlString = privateURL.appending(Constants.LOGIN_URL)
        
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
    
    func viewDetailRequest(jobId: String, jobType: String) -> DataRequest {
        let urlString = businessURL.appending(Constants.VIEW_DETAIL_URL)
        
        var param = [String: Any]()
        param["Token"] = DataManager.shareInstance.userInfo?.Token
        param["id"] = jobId
        param["type"] = jobType
        
        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: JSONEncoding.default,
                                        headers: headers)
    }
    
    // getWarningInDay
    func getWarningInDay() -> DataRequest {
        let urlString = businessURL.appending(Constants.GET_WARNING_IN_DAY_URL)
        
        var param = [String: Any]()
        param["Token"] = DataManager.shareInstance.userInfo?.Token
        
        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: JSONEncoding.default,
                                        headers: headers)
    }
    
    // getJobWarningUnMake
    func getJobWarningUnMake() -> DataRequest {
        let urlString = businessURL.appending(Constants.GET_JOB_WARNING_UN_MAKE_URL)
        
        var param = [String: Any]()
        param["Token"] = DataManager.shareInstance.userInfo?.Token
        
        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: JSONEncoding.default,
                                        headers: headers)
    }
    
    // getApproveType
    func getApproveType() -> DataRequest {
        let urlString = businessURL.appending(Constants.GET_APPROVE_TYPE_URL)
        
        var param = [String: Any]()
        param["Token"] = DataManager.shareInstance.userInfo?.Token
        
        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: JSONEncoding.default,
                                        headers: headers)
    }
    
    // getUserApprove
    func getUserApprove() -> DataRequest {
        let urlString = businessURL.appending(Constants.GET_USER_APPROVE_URL)
        
        var param = [String: Any]()
        param["Token"] = DataManager.shareInstance.userInfo?.Token
        
        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: JSONEncoding.default,
                                        headers: headers)
    }
    
    // doApprove
    func doApprove(approveTypeId: String) -> DataRequest {
        let urlString = businessURL.appending(Constants.DO_APPROVE_URL)
        
        var param = [String: Any]()
        param["Token"] = DataManager.shareInstance.userInfo?.Token
        param["id"] = approveTypeId
        
        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: JSONEncoding.default,
                                        headers: headers)
    }
    
    // getTransApproveHistory
    func getTransApproveHistory() -> DataRequest {
        let urlString = businessURL.appending(Constants.GET_TRANS_APPROVE_HIS_URL)
        
        var param = [String: Any]()
        param["Token"] = DataManager.shareInstance.userInfo?.Token
        
        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: JSONEncoding.default,
                                        headers: headers)
    }
    
    // getTransactions
    func getTransactions(idCustomer: String, businessType: String) -> DataRequest {
        let urlString = businessURL.appending(Constants.DO_GET_TRANSACTIONS_URL)
        
        var param = [String: Any]()
        param["Token"] = DataManager.shareInstance.userInfo?.Token
        param["idCustomer"] = idCustomer
        param["businessType"] = businessType
        
        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: JSONEncoding.default,
                                        headers: headers)
    }
}
