//
//  LoginResponseData.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/7/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class UserLoginData: Codable {
    var Token:String?
    var AccountId:String?
    var IdImplementer:String?
    var UserName:String?
}

class LoginResponseData: Codable {
    var ErrorCode:String?
    var Description:String?
    var UserLogin:UserLoginData?
    var Webservice:String?
}
