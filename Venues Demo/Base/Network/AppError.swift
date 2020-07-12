//
//  AppError.swift
//  Venues Demo
//
//  Created by Mohammad Shaker on 7/12/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import UIKit
import Moya

enum AppErrorCode: Int {
    case tokenExpired = 401
    case internalServerError = 500
    case generalError = 0
}

struct AppError: Error {
    var errorCode: AppErrorCode = .generalError
    var serverErrorCode: Int?
    var errorMessage: String {
        return ErrorHandler.errorMesage(forErrorCode: errorCode)
    }
}

class ErrorHandler {
    class func errorMesage(forErrorCode error: AppErrorCode) -> String {
        switch error {
        case .tokenExpired:
            return "Token Expired"
        case .internalServerError:
            return "Internal Server Error"
        default:
            return "General Error"
        }
    }
}
