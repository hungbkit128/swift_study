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
    
    // getWarningInDay
    func getWarningInDay(completion: @escaping(([JobWarningModel], NSError?) -> Void)) {
        
        if let request = APIRequestProvider.shareInstance?.getWarningInDay() {
            self.startRequest(request) { (_ json: JSON, _ error: NSError?) in
                if error == nil {
                    var listJob = [JobWarningModel]()
                    for (_, subJson) in json["LstJobWarning"] {
                        let job = JobWarningModel(subJson)
                        listJob.append(job)
                    }
                    completion(listJob, error)
                } else {
                    completion([], error)
                }
            }
        }
    }
    
    // getJobWarningUnMake
    func getJobWarningUnMake(completion: @escaping(([JobWarningModel], NSError?) -> Void)) {
        
        if let request = APIRequestProvider.shareInstance?.getJobWarningUnMake() {
            self.startRequest(request) { (_ json: JSON, _ error: NSError?) in
                if error == nil {
                    var listJob = [JobWarningModel]()
                    for (_, subJson) in json["LstJobWarning"] {
                        let job = JobWarningModel(subJson)
                        listJob.append(job)
                    }
                    completion(listJob, error)
                } else {
                    completion([], error)
                }
            }
        }
    }
    
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
                DLog(json.description)
                let userInfo = DetailTransModel(json)
                completion(userInfo, error)
            }
        }
    }
    
    // getApproveType
    func getApproveType(completion: @escaping([ApproveTypeModel], NSError?) -> Void) {
        if let request = APIRequestProvider.shareInstance?.getApproveType() {
            self.startRequest(request) { (_ json: JSON, _ error: NSError?) in
                var typeModels = [ApproveTypeModel]()
                for (_, subJson) in json["LstApproveType"] {
                    let model = ApproveTypeModel(subJson)
                    typeModels.append(model)
                }
                completion(typeModels, error)
            }
        }
    }
    
    // getUserApprove
    func getUserApprove(completion: @escaping([AccountApproveModel], NSError?) -> Void) {
        if let request = APIRequestProvider.shareInstance?.getUserApprove() {
            self.startRequest(request) { (_ json: JSON, _ error: NSError?) in
                var accModels = [AccountApproveModel]()
                for (_, subJson) in json["LstAccountApprove"] {
                    let model = AccountApproveModel(subJson)
                    accModels.append(model)
                }
                completion(accModels, error)
            }
        }
    }
    
    
    //doApprove
    func doApprove(approveTypeId: String,
                   completion: @escaping(DetailTransModel?, NSError?) -> Void) {
        
        if let request = APIRequestProvider.shareInstance?.doApprove(approveTypeId: approveTypeId) {
            self.startRequest(request) { (_ json: JSON, _ error: NSError?) in
                let userInfo = DetailTransModel(json["TransModel"])
                completion(userInfo, error)
            }
        }
    }
    
    // getTransApproveHistory
    func getTransApproveHistory(completion: @escaping([ApproveHistoryModel], NSError?) -> Void) {
        if let request = APIRequestProvider.shareInstance?.getTransApproveHistory() {
            self.startRequest(request) { (_ json: JSON, _ error: NSError?) in
                var hisModels = [ApproveHistoryModel]()
                for (_, subJson) in json["LstHisApprove"] {
                    let model = ApproveHistoryModel(subJson)
                    hisModels.append(model)
                }
                completion(hisModels, error)
            }
        }
    }
}
