//
//  ItemDashboardService.swift
//  CBCT-Viettel
//
//  Created by Hoang on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class ItemDashboardService: APIServiceObject {

    func getDashboardList(_ searchModel: Any?,
                          completion: @escaping ((ListItemDashboardModel) -> Void),
                          failse: @escaping (_ err: NSError?) -> Void) {

        if let file = Bundle.main.url(forResource: "vbi:dashboard:getList", withExtension: "json") {
            let data = try? Data(contentsOf: file)
            let jsonObject = try? JSON(data: data!)
            //let dto = ListItemDashboardDTO(jsonObject!["content"])
            let model = ListItemDashboardModel(jsonObject!["content"])
            completion (model)

        } else {
            if let request = APIRequestProvider.shareInstance?.getListDashBoardItem(searchModel) {
                self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
                    if error != nil {
                        failse(error)
                    } else {
                        //let dto = ListItemDashboardDTO(json)
                        let model = ListItemDashboardModel(json)
                        completion (model)
                    }
                }
            }
        }
    }

    func getDataStackBarChart(searchObject: DashboardSearchCritieria?,
                              viewType: String?,
                              completion: @escaping (_ data: GVerticalStackBarChartData?, _ error: NSError?) -> Void) {
        if let file = Bundle.main.url(forResource: "fullRank", withExtension: "json") {
            let data = try? Data(contentsOf: file)
            let mJson = try? JSON(data: data!)
            let jsonObject = mJson!["content"]
            let currentType = ViewTypeDTO(jsonObject["currentType"])
            var viewTypes: [ViewTypeDTO] = []

            for (_, subJson) in jsonObject["viewTypes"] {
                let viewTypeDTO = ViewTypeDTO(subJson)
                viewTypes.append(viewTypeDTO)
            }

            let stackBarChartDTO = GroupColumnChartDTO(jsonObject["chartData"])
            let haveComment = jsonObject["haveComment"].bool
            var commentData: CommentDataDTO?
            if (jsonObject["commentData"].isNull == false) {
                commentData = CommentDataDTO(jsonObject["commentData"])
            }
            let asc = jsonObject["asc"].bool
            let verticalStackBarChartData = GVerticalStackBarChartViewMapping.mappingDataFromDTO(stackBarChartDTO, currentType, viewTypes, asc)
            verticalStackBarChartData?.commentData = commentData
            verticalStackBarChartData?.haveComment = haveComment
            completion (verticalStackBarChartData, nil)
        } else {
            var target: TargetDashboardModel?
            if let search = searchObject {
                if (search.targets.count) > 0 {
                    target = searchObject?.targets.first
                }
                if let request = APIRequestProvider.shareInstance?.stackBarChartExtend(target: target,
                                                                                   province: search.province,
                                                                                   district: search.district,
                                                                                   date: search.toDate,
                                                                                   viewType: viewType) {
                self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
                    if error == nil {
                        let currentType = ViewTypeDTO(json["currentType"])
                        var viewTypes: [ViewTypeDTO] = []

                        for (_, subJson) in json["viewTypes"] {
                            let viewTypeDTO = ViewTypeDTO(subJson)
                            viewTypes.append(viewTypeDTO)
                        }

                        let asc = json["asc"].bool
                        let stackBarChartDTO = GroupColumnChartDTO(json["chartData"])
                        let verticalStackBarChartData = GVerticalStackBarChartViewMapping.mappingDataFromDTO(stackBarChartDTO, currentType, viewTypes, asc)
                        completion (verticalStackBarChartData, nil)
                    } else {
                        completion (nil, error)
                    }
                }
                }
            }
        }
    }

    func getFullRaking(_ searchObject: DashboardSearchCritieria?,
                       _ asc: Bool?,
                       _ type: RankingTypeModel?,
                       completion: @escaping (_ models: GVerticalStackBarChartData?, _ error: NSError?) -> Void) {

        var target: TargetDashboardModel?
        if let targets = searchObject?.targets {
            if targets.count > 0 {
                target = targets.first
            }
        }

        if let file = Bundle.main.url(forResource: "fullRank", withExtension: "json") {
            let data = try? Data(contentsOf: file)
            let mJson = try? JSON(data: data!)
            let jsonObject = mJson!["content"]

            let currentType = ViewTypeDTO(jsonObject["currentType"])
            var viewTypes: [ViewTypeDTO] = []

            for (_, subJson) in jsonObject["viewTypes"] {
                let viewTypeDTO = ViewTypeDTO(subJson)
                viewTypes.append(viewTypeDTO)
            }

            let stackBarChartDTO = GroupColumnChartDTO(jsonObject["chartData"])
            let verticalStackBarChartData = GVerticalStackBarChartViewMapping.mappingDataRankingFromDTO(stackBarChartDTO, currentType, viewTypes, asc)
            completion (verticalStackBarChartData, nil)
        } else {

            let KEY_CACHE = APIConstant.API_FULL_RANKING
                + SaveCacheCommons.genKeyFullRaking(target: target,
                                                    province: searchObject?.province,
                                                    district: searchObject?.district,
                                                    date: searchObject?.toDate,
                                                    asc: asc,
                                                    type: type)

            var verticalStackBarChartDataCache: GVerticalStackBarChartData?
            var dataVersionOld: String?
            if let itemCache = ItemCacheDataService.shareObject.getItemWithUrlCache(KEY_CACHE),
                let jsonString = itemCache.content,
                let data = jsonString.data(using: .utf8),
                let json = try? JSON(data: data) {
                
                dataVersionOld = itemCache.dataVersion
                let stackBarChartDTO = GroupColumnChartDTO(json)
                verticalStackBarChartDataCache = GVerticalStackBarChartViewMapping.mappingDataRankingFromDTO(stackBarChartDTO, nil, nil, asc)
            }

            if CacheProcess.isWorkOffline {
                if verticalStackBarChartDataCache == nil {
                    let errorDefault = NSError(domain: LocalizableHelper.getTextByKey("offline.message.nodata"),
                                               code: -128,
                                               userInfo: [NSLocalizedDescriptionKey: LocalizableHelper.getTextByKey("offline.message.nodata")])
                    DispatchQueue.main.async {
                        completion(nil, errorDefault)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(verticalStackBarChartDataCache, nil)
                    }
                }
            } else {
                if let request = APIRequestProvider.shareInstance?.fullRaking(target: target,
                                                                          province: searchObject?.province,
                                                                          district: searchObject?.district,
                                                                          date: searchObject?.toDate,
                                                                          asc: asc,
                                                                          type: type,
                                                                          isAutoRequest: false,
                                                                          dataVersionOld: dataVersionOld) {

                    RequestWithCache.shared.processDataForCacheRequest(APIConstant.API_FULL_RANKING, KEY_CACHE, request) {
                        (_ json: JSON, _ error: NSError?, _ data: String?) in
                        if error == nil {
                            DispatchQueue.main.async {
                                let stackBarChartDTO = GroupColumnChartDTO(json)
                                let verticalStackBarChartData = GVerticalStackBarChartViewMapping.mappingDataRankingFromDTO(stackBarChartDTO, nil, nil, asc)
                                completion (verticalStackBarChartData, nil)
                            }
                        } else {
                            DispatchQueue.main.async {
                                completion (nil, error)
                            }
                        }
                    }
                }
            }
        }
    }

    func getFullUserAnalysis(_ filterObject: FilterMetadataModel, _ sortTop: Bool?,
                       completion: @escaping (_ models: ItemDashboardDataCombineBarChart?, _ error: NSError?) -> Void) {
        if let request = APIRequestProvider.shareInstance?.getFullUserAnalysis(filterObject, sortTop) {

            self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
                if error == nil {
                    let dashboardDTO = DashboardDataDetailDTO(json)
                    let combineChart = ItemDashboardDataCombineBarChart(dashboardDTO)
                    completion (combineChart, nil)
                } else {
                    completion (nil, error)
                }
            }
        }
    }

    func getZoomUrlData(_ filterObject: FilterMetadataModel, _ sortTop: Bool?, _ chartType: ChartType?,
                             completion: @escaping (_ models: ItemDashboardDataModel?, _ error: NSError?) -> Void) {

        if let request = APIRequestProvider.shareInstance?.getFullUserLogTD(filterObject, sortTop) {
            self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
                if error == nil {
                    let dashboardDTO = DashboardDataDetailDTO(json)
                    if chartType == ChartType.vertialStackBarChart {
                        let combineChart = ItemDashboardDataCombineBarChart(dashboardDTO)
                        completion (combineChart, nil)
                    } else if chartType == ChartType.candleStickChart {
                        let candleChart = ItemDashboardDataCandleStickChart(dashboardDTO)
                        completion (candleChart, nil)
                    } else if chartType == ChartType.groupBarChart {
                        let groupBarChart = ItemDashboardDataGroupBarChart(dashboardDTO)
                        completion (groupBarChart, nil)
                    }
                } else {
                    completion (nil, error)
                }
            }
        }
    }
}
