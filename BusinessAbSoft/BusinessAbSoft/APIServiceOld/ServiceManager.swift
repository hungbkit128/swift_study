//
//  ServiceManager.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/14/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

protocol ServiceManagerProtocol {
    func didFinishService(data:Any, funcName:String)
    func didErrorService(errString:String, funcName:String)
}

class ServiceManager {
    
    static var delegate:ServiceManagerProtocol? = nil
    static var token:String? = nil
    static var userData:UserInfoModel? = nil
    
    static func httpPost(urlString:String, jsonData:Any) {
        
        var urlStringFull:String = ""
        if urlString.elementsEqual(Constants.LOGIN_URL)
            || urlString.elementsEqual(Constants.REGISTER_URL) {
            urlStringFull = Constants.BASE_URL + urlString
        } else {
            urlStringFull = Constants.BUSINESS_URL + urlString
        }
        
        let url = URL(string: urlStringFull)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonData, options: []) else { return }
        request.httpBody = httpBody
        
        print(httpBody)
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            if error != nil {
                print(error as Any)
                delegate?.didErrorService(errString: NSURLError.getErrorByDesc(descString:error.debugDescription), funcName: urlString)
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(json)
                    let responseCommon = try JSONDecoder().decode(ResponseCommon.self, from: data!)
                    if "1" == responseCommon.ErrorCode {
                        delegate?.didFinishService(data: data as Any, funcName: urlString)
                    } else {
                        delegate?.didErrorService(errString: responseCommon.Description!, funcName: urlString)
                    }
                } catch {
                    print(error)
                    delegate?.didErrorService(errString:error.localizedDescription, funcName: urlString)
                }
            }
        }.resume()
    }
    
    static func httpGet(urlString:String) {
        let urlStringFull:String = Constants.BASE_URL + urlString
        let url = URL(string: urlStringFull)!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            print(error as Any)
            
            if let data = data {
                print(data)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
