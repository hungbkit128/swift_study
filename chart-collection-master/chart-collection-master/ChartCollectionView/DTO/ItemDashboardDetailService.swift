//
//  ItemDashboardDetailService.swift
//  CBCT-Viettel
//
//  Created by Hoang on 4/24/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class ItemDashboardDetailService: APIServiceObject {

    func getDashboardTargetBlocks(_ searchCriteria: DashboardSearchCritieria,
                                  completion: @escaping((_ dataModel: ListItemDashboardModel?, _ noDataModels: [GroupNoDataModel]?, _ errStr: NSError?) -> Void)) {

        if let file = Bundle.main.url(forResource: "vbi:dashboard:services", withExtension: "json") {
            let data = try? Data(contentsOf: file)
            let jsonObject = try? JSON(data: data!)
            //let dto = ListItemDashboardDTO(jsonObject!["content"])
            let model = ListItemDashboardModel(jsonObject!["content"])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                completion (model, nil, nil)
            })
        } else {
            DispatchQueue.global(qos: .background).async {
                let KEY_CACHE = APIConstant.API_DASHBOARD_ANALYSTIC
                    + SaveCacheCommons.genKeyDashboardTargetBlocks2(searchCriteria)

                var modelData: ListItemDashboardModel? = nil
                var dataVersionOld: String?
                if let itemCache = ItemCacheDataService.shareObject.getItemWithUrlCache(KEY_CACHE),
                    let jsonString = itemCache.content,
                    let data = jsonString.data(using: .utf8),
                    let json = try? JSON(data: data) {
                    
                    dataVersionOld = itemCache.dataVersion
                    //let dto = ListItemDashboardDTO(json)
                    modelData = ListItemDashboardModel(json)
                }

                if CacheProcess.isWorkOffline {
                    if modelData == nil {
                        let errorDefault = NSError(domain: LocalizableHelper.getTextByKey("offline.message.nodata"),
                                                   code: 128,
                                                   userInfo: [NSLocalizedDescriptionKey: LocalizableHelper.getTextByKey("offline.message.nodata")])
                        DispatchQueue.main.async {
                            completion (nil, nil, errorDefault)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion (modelData, nil, nil)
                        }
                    }
                } else {
                    // start request get-block
                    let requestx = APIRequestProvider.shareInstance?.getDashboardTargetBlocks2(searchCriteria, false, dataVersionOld)
                    if let requestGetBlock = requestx {
                        self.serviceAgent.startRequestWithDataVersion(requestGetBlock) {
                            (_ json: JSON, _ error: NSError?, _ dataVersion: String?) in
                            if error != nil {
                                if error?.code == -1001 {
                                    DispatchQueue.main.async {
                                        completion (modelData, nil, error)
                                    }
                                } else if error?.code == 500 {
                                    var nodata: [GroupNoDataModel] = []
                                    if let dict = error?.userInfo {
                                        if let json = dict["data"] as? JSON {
                                            let content = json["content"]
                                            for sub in content["listSuggestGroup"].array! {
                                                let dto = GroupNoDataDTO(sub)
                                                let model = GroupNoDataModel(dto)
                                                nodata.append(model)
                                            }
                                        }
                                    }
                                    DispatchQueue.main.async {
                                        completion(nil, nodata, nil)
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        completion(nil, nil, error)
                                    }
                                }
                            } else {
                                if json.null == nil {
                                    // save keyData
                                    let dateInit = Date().resetToStartOfDay()
                                    let timeValue = Int64(dateInit.timeIntervalSince1970) * 1000
                                    let itemCache = ItemCacheEntityDTO(apiCache: APIConstant.API_DASHBOARD_ANALYSTIC,
                                                                       areaCode: DataManager.shareInstance.currentUserPosition?.areaCode,
                                                                       timeCache: timeValue,
                                                                       urlCache: KEY_CACHE,
                                                                       content: json.rawString(),
                                                                       dataVersion: dataVersion)
                                    ItemCacheDataService.shareObject.saveItemDTO(itemCache)
                                    
                                    //let dto = ListItemDashboardDTO(json)
                                    let model = ListItemDashboardModel(json)
                                    DispatchQueue.main.async {
                                        completion (model, nil, nil)
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        completion (modelData, nil, error)
                                    }
                                }
                            }
                        }
                    }
                    // end request
                }
            }
        }
    }

    func getStaffInfo(_ email: String?, completionBlock: @escaping((StaffInfoModel?, NSError?) -> Void)) {

        if let file = Bundle.main.url(forResource: "v2_getPersonalInfo", withExtension: "json") {
            let data = try? Data(contentsOf: file)
            let jsonObject = try? JSON(data: data!)
            let dto = StaffInfoDTO(jsonObject!["content"])
            let model = StaffInfoModel(dto)
            let delayInSeconds = 2.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                completionBlock(model, nil)
            }
        } else {
            if let request = APIRequestProvider.shareInstance?.getStaffInfo(email: email) {
            self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
                if error != nil {
                    completionBlock(nil, error)
                } else {
                    let dto = StaffInfoDTO(json)
                    let model = StaffInfoModel(dto)
                    completionBlock(model, nil)
                }
            }
            }
        }
    }
}
