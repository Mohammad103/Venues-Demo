//
//  MoyaProviderExtensions.swift
//  Venues Demo
//
//  Created by Mohammad Shaker on 7/12/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import Foundation
import Moya

extension TargetType {
    func toString() -> String {
        var requestDataString: String = "🚀"
        requestDataString = requestDataString + method.rawValue + " " + baseURL.absoluteString + path + "\n"
        requestDataString = requestDataString + "➣Headers: \n \(headers?.toJsonString() ?? "💩😿 Failed to produce String")"
        requestDataString = requestDataString + "\n\n➣Body: \n \(task.parametersString())\n"
        return requestDataString
    }
    
    func needsAuthentication() -> Bool {
        return true
    }
}

extension Task {
    func parametersString() -> String {
        switch self {
        case .requestPlain:
            return "✈️ Plain String Request"
        case .requestParameters(parameters: let parameters, _):
            return parameters.toJsonString() ?? "💩😿 Failed to deduce parameters"
        default:
            return "🤷🏻‍♂️ None"
        }
    }
}
