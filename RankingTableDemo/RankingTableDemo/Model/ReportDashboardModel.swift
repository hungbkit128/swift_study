//
//  ReportDashboardModel.swift
//  CBCT-Viettel
//
//  Created by GEM on 5/24/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReportDashboardModel: NSObject {
    var filterMetadata: FilterMetadataModel?
    var reportName: String?
    var unit: String?
    var mainBlock: MainBlockModel?
    var otherInfo: [InfoModel] = []
    var searchItem: DashboardSearchCritieria?
    var sparkLines: ItemDashboardDataLineChart?
    var typeCompress: TypeCompressNumber = .normal

    init(_ dto: ReportDashboardDTO) {
        filterMetadata = FilterMetadataModel(dto.filterMetadata)
        reportName = dto.reportName
        unit = dto.unit
        sparkLines = dto.sparkLines
        mainBlock = MainBlockModel(dto.mainBlock)
        for subDTO in dto.otherInfo {
            let model = InfoModel.dataModelFromDTO(subDTO, unit)
            otherInfo.append(model)
        }

        if let item = filterMetadata {
            searchItem = DashboardSearchCritieria.initWithFilterMetadataModel(item)
        }
        
        self.typeCompress = DataManager.shareInstance.currencyUnit
      
    }

    func doUpdateTypeCompress() {
        if typeCompress == .normal {
            typeCompress = .compress
        } else {
            typeCompress = .normal
        }
    }

    func getUnit() -> String? {
        switch typeCompress {
        case .normal:
            return unit
        case .compress:
            if let unit = mainBlock?.prettyUnit {
                return unit
            }
            return unit
        }
    }
}

class UnitModel: NSObject {
    var group: String?
    var province: String?
    var district: String?
    var station: String?
    var deptLevel: Int?

    override init() {

    }

    init(_ dto: UnitDTO) {
        group = dto.group
        province = dto.province
        district = dto.district
        station = dto.station
        deptLevel = dto.deptLevel
    }

    func clone() -> UnitModel {
        let cloneObj = UnitModel()
        cloneObj.group      = self.group
        cloneObj.province   = self.province
        cloneObj.district   = self.district
        cloneObj.station    = self.station
        cloneObj.deptLevel  = self.deptLevel
        return cloneObj
    }

    func getParentUnit(_ unitCode: String, _ groupId: Int) -> ProvinceDistrictModel? {
        return ProvinceDistrictModel.findModelFromId(code: unitCode, groupId: groupId)
    }
    
    func getUnit(_ groupId: Int) -> ProvinceDistrictModel? {
        if let unitCode = group {
            return ProvinceDistrictModel.findModelFromId(code: unitCode, groupId: groupId)
        }
        return nil
    }

    func getProvince(_ groupId: Int) -> ProvinceDistrictModel? {
        if let provinceCode = province {
            return ProvinceDistrictModel.findModelFromId(code: provinceCode, groupId: groupId)
        }
        return nil
    }

    func getDistrict(_ groupId: Int) -> ProvinceDistrictModel? {
        if let districtCode = district {
            return ProvinceDistrictModel.findModelFromId(code: districtCode, groupId: groupId)
        }
        return nil
    }

    func getStation() -> StationModel? {
        if let stationCode = station {
            return StationModel(stationCode: stationCode, districtCode: district)
        }
        return nil
    }

    func toNSDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["group"]     = group
        dictionary["province"]  = province
        dictionary["district"]  = district
        dictionary["station"]   = station
        dictionary["deptLevel"] = deptLevel
        return dictionary
    }

    func convertToJSON() -> JSON? {
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.toNSDictionary(),
                                                          options: .prettyPrinted)
        if let data = jsonData {
            if data.count > 0 {
                let json = try? JSON.init(data: data)
                return json
            }
            return nil
        }
        return nil
    }
}

class MainBlockModel: NSObject {
    var performValue: String?
    var planValue: String?
    var performPercent: Double?
    var performColor: String?
    var prettyPlanValue: String?
    var prettyPerformValue: String?
    var prettyUnit: String?

    init(_ dto: MainBlockDTO?) {
        performValue        = dto?.performValue
        planValue           = dto?.planValue
        performPercent      = dto?.performPercent
        performColor        = dto?.performColor
        prettyPlanValue     = dto?.prettyPlanValue
        prettyPerformValue  = dto?.prettyPerformValue
        prettyUnit          = dto?.prettyUnit
    }

    func getPlanValue(_ type: TypeCompressNumber) -> String? {
        switch type {
        case .normal:
            return planValue
        case .compress:
            if let planValue = prettyPlanValue {
                return planValue
            }
            return planValue
        }
    }

    func getPerformValue(_ type: TypeCompressNumber) -> String? {
        switch type {
        case .normal:
            return performValue
        case .compress:
            if let performValue = prettyPerformValue {
                return performValue
            }
            return performValue
        }
    }
}

class InfoModel: NSObject {
    var type: ReportInfo

    public init(_ dto: InfoDTO, _ unit: String? ) {
        type = dto.type
    }

    class func dataModelFromDTO(_ dto: InfoDTO, _ unit: String?) -> InfoModel {
        switch dto.type {
        case .perform:
            return PerformInfoModel(dto, unit)
        case .delta:
            return DeltaInfoModel(dto, unit)
        default:
            break
        }

        return InfoModel(dto, unit)
    }
}

class PerformInfoModel: InfoModel {
    var data: PerformModel?

    override init(_ dto: InfoDTO, _ unit: String?) {
        data = PerformModel(dto, unit)

        super.init(dto, unit)
    }
}

class DeltaInfoModel: InfoModel {
    var data: DeltaModel?

    override init(_ dto: InfoDTO, _ unit: String?) {
        data = DeltaModel(dto, unit)

        super.init(dto, unit)
    }

}

class PerformModel: NSObject {
    var title: String?
    var performValue: String?
    var planValue: String?
    var performPercent: Double?
    var performColor: String?
    var prettyPlanValue: String?
    var prettyPerformValue: String?
    var prettyPerformUnit: String?
    var prettyDeltaUnit: String?
    var unit: String?
    var completedType: CompletedType = .unknown

    init(_ dto: InfoDTO, _ unit: String?) {
        self.unit = unit
        let json = dto.data
        title = json["title"].string
        performValue = json["performValue"].string
        planValue = json["planValue"].string
        performPercent = json["performPercent"].double
        performColor = json["performColor"].string
        prettyPlanValue     = json["prettyPlanValue"].string
        prettyPerformValue  = json["prettyPerformValue"].string
        prettyPerformUnit        = json["prettyPerformUnit"].string
        prettyDeltaUnit          = json["prettyDeltaUnit"].string
        if let type = json["completedType"].string {
            completedType = CompletedType.typeFromServer(type)
        }
    }

    func getUnit(_ type: TypeCompressNumber) -> String? {
        switch type {
        case .normal:
            return unit
        case .compress:
            if let unit = prettyPerformUnit {
                return unit
            }
            return unit
        }
    }

    func getPlanValue(_ type: TypeCompressNumber) -> String? {
        switch type {
        case .normal:
            return planValue
        case .compress:
            if let planValue = prettyPlanValue {
                return planValue
            }
            return planValue
        }
    }

    func getPerformValue(_ type: TypeCompressNumber) -> String? {
        switch type {
        case .normal:
            return performValue
        case .compress:
            if let performValue = prettyPerformValue {
                return performValue
            }
            return performValue
        }
    }
}

class DeltaModel: NSObject {
    var title: String?
    var performValue: String?
    var deltaValue: String?
    var deltaPercent: String?
    var increase: Bool?
    var deltaColor: String?
    var prettyDeltaValue: String?
    var prettyPerformValue: String?
    var prettyPerformUnit: String?
    var prettyDeltaUnit: String?
    var unit: String?

    init(_ dto: InfoDTO, _ unit: String?) {
        self.unit = unit
        let json = dto.data
        title = json["title"].string
        performValue = json["performValue"].string
        deltaValue = json["deltaValue"].string
        deltaPercent = json["deltaPercent"].string
        increase = json["increase"].bool
        deltaColor = json["deltaColor"].string
        prettyDeltaValue    = json["prettyDeltaValue"].string
        prettyPerformValue  = json["prettyPerformValue"].string
        prettyPerformUnit   = json["prettyPerformUnit"].string
        prettyDeltaUnit     = json["prettyDeltaUnit"].string
    }

    func getUnit(_ type: TypeCompressNumber) -> String? {
        switch type {
        case .normal:
            return unit
        case .compress:
            if let unit = prettyDeltaUnit {
                return unit
            }
            return unit
        }
    }

    func getDeltaValue(_ type: TypeCompressNumber) -> String? {
        switch type {
        case .normal:
            return deltaValue
        case .compress:
            if let delta = prettyDeltaValue {
                return delta
            }
            return deltaValue
        }
    }

    func getPerformValue(_ type: TypeCompressNumber) -> String? {
        switch type {
        case .normal:
            return performValue
        case .compress:
            if let perfrom = prettyPerformValue {
                return perfrom
            }
            return performValue
        }
    }
}
