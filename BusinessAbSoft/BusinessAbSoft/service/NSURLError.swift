//
//  NSURLError.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/1/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import Foundation

class NSURLError: NSObject {
    
    static func getErrorByDesc(descString:String) -> String {
        if descString.contains(NSURLErrorNetworkConnectionLost) || descString.contains(NSURLErrorNotConnectedToInternet) {
            return "Lỗi không có kết nối internet"
        } else if descString.contains(NSURLErrorTimedOut) {
            return "Lỗi không có phản hồi từ server - request time out"
        } else if descString.contains(NSURLErrorCannotFindHost) {
            return "Lỗi không tìm thấy địa chỉ IP của server"
        } else {
            return descString
        }
    }
        
    static let NSURLErrorUnknown =          "-1"
    static let NSURLErrorCancelled =        "-999"
    static let NSURLErrorBadURL =           "-1000"
    static let NSURLErrorTimedOut =         "-1001"
    static let NSURLErrorUnsupportedURL =   "-1002"
    static let NSURLErrorCannotFindHost =   "-1003"

    static let NSURLErrorCannotConnectToHost =         "-1004"
    static let NSURLErrorNetworkConnectionLost =       "-1005"
    static let NSURLErrorDNSLookupFailed =             "-1006"
    static let NSURLErrorHTTPTooManyRedirects =        "-1007"
    static let NSURLErrorResourceUnavailable =         "-1008"
    static let NSURLErrorNotConnectedToInternet =      "-1009"

    static let NSURLErrorRedirectToNonExistentLocation =   -1010
    static let NSURLErrorBadServerResponse =               -1011
    static let NSURLErrorUserCancelledAuthentication =     -1012
    static let NSURLErrorUserAuthenticationRequired =      -1013
    static let NSURLErrorZeroByteResource =                -1014
    static let NSURLErrorCannotDecodeRawData =             -1015
    static let NSURLErrorCannotDecodeContentData =         -1016
    static let NSURLErrorCannotParseResponse =             -1017

    static let NSURLErrorFileDoesNotExist =            -1100
    static let NSURLErrorFileIsDirectory =             -1101
    static let NSURLErrorNoPermissionsToReadFile =     -1102

    // SSL errors
    static let NSURLErrorSecureConnectionFailed =          -1200
    static let NSURLErrorServerCertificateHasBadDate =     -1201
    static let NSURLErrorServerCertificateUntrusted =      -1202
    static let NSURLErrorServerCertificateHasUnknownRoot = -1203
    static let NSURLErrorServerCertificateNotYetValid =    -1204
    static let NSURLErrorClientCertificateRejected =       -1205
    static let NSURLErrorClientCertificateRequired =       -1206
    static let NSURLErrorCannotLoadFromNetwork =           -2000

    // Download and file I/O errors
    static let NSURLErrorCannotCreateFile =        -3000
    static let NSURLErrorCannotOpenFile =          -3001
    static let NSURLErrorCannotCloseFile =         -3002
    static let NSURLErrorCannotWriteToFile =       -3003
    static let NSURLErrorCannotRemoveFile =        -3004
    static let NSURLErrorCannotMoveFile =          -3005

    static let NSURLErrorDownloadDecodingFailedMidStream = -3006
    static let NSURLErrorDownloadDecodingFailedToComplete = -3007
}
