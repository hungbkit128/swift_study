//
//  Constants.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/16/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class Constants {
    // URL
    static let BASE_URL = "http://118.70.190.38:8686"
    static let BUSINESS_URL = "http://118.70.190.38:8088"
    static let LOGIN_URL = "/absoft/login"
    static let REGISTER_URL = "/absoft/register"
    
    // home
    static let GET_WARNING_IN_DAY_URL = "/absoft/getWarningInDay"
    static let GET_JOB_WARNING_UN_MAKE_URL = "/absoft/getJobWarningUnMake"
    static let VIEW_DETAIL_URL = "/absoft/viewDetail"
    static let DO_APPROVE_URL = "/absoft/doApprove"
    static let GET_USER_APPROVE_URL = "/absoft/getUserApprove"
    static let GET_APPROVE_TYPE_URL = "/absoft/getApproveType"
    
    // report
    static let INIT_GROUP_REPORT_URL = "/absoft/initGroupReport"
    static let INIT_REPORT_TYPE_URL = "/absoft/initReportType"
    static let DO_REPORT_URL = "/absoft/doReport"
    
    // customer
    static let DO_GET_CUSTOMER_URL = "/absoft/doGetCustomer"
    static let DO_INSERT_CUSTOMER_URL = "/absoft/doInsertCustomer"
    
    // deal
    static let SEARCH_HISTORY_URL = "/absoft/searcLHistory"
    static let LOAD_DATA_URL = "/absoft/loadData"
    static let UPLOAD_URL = "/absoft/upload"
}
