//
//  RequestManager.swift
//  Venues Demo
//
//  Created by Mohammad Shaker on 7/12/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

typealias RequestCompletionHandler = (Any?, AppError?) -> ()

class RequestManager {
    
    class func beginRequest<T: Mappable, ProvidertType: TargetType>(withTargetType targetType: ProvidertType.Type, andTarget target: ProvidertType, responseModel model: T.Type, andHandler handler: @escaping RequestCompletionHandler) {
        let cachingPlugin = NetworkDataCachingPlugin(configuration: .default,
                                                    inMemoryCapacity: 4 * 1024 * 1024,
                                                    diskCapacity: 20 * 1024 * 1024,
                                                    diskPath: nil)
        let provider = MoyaProvider<ProvidertType> (plugins: [cachingPlugin])
        print(target.toString())
        provider.request(target) { (result) in
            switch result {
            case let .success(moyaResponse):
                guard moyaResponse.statusCode >= 200 && moyaResponse.statusCode < 300 else {
                    var appError: AppError = AppError(errorCode: .generalError , serverErrorCode: moyaResponse.statusCode)
                    if let appErrorCode = AppErrorCode(rawValue: moyaResponse.statusCode) {
                        appError.errorCode = appErrorCode
                    }
                    handler(nil, appError)
                    return
                }
                
                if let parsedObject = ParsingHandler.parseObject(responseData: moyaResponse.data, toModel: model) {
                    handler(parsedObject, nil)
                } else if let parsedArray = ParsingHandler.parseArray(responseData: moyaResponse.data, toModel: model) {
                    handler(parsedArray, nil)
                } else if ParsingHandler.isNull(responseData: moyaResponse.data) {
                    handler(nil, nil)
                } else {
                    let appError: AppError = AppError(errorCode: .generalError, serverErrorCode: nil)
                    handler(nil, appError)
                }
                break
            case let .failure(error):
                print(error.localizedDescription)
                let appError: AppError = AppError(errorCode: .generalError, serverErrorCode: error.response?.statusCode)
                handler(nil, appError)
                break
            }
        }
    }
    
    func clearCachedRequests() {
        URLCache.shared.removeAllCachedResponses()
    }
}
