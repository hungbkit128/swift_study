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
    
    func getTransactions(idCustomer: String,
                         businessType: String,
                         completion: @escaping(([JobWarningModel], NSError?) -> Void)) {
        
        if let request = APIRequestProvider.shareInstance?.getTransactions(idCustomer: idCustomer, businessType: businessType) {
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
}
