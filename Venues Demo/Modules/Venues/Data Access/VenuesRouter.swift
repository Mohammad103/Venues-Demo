//
//  VenuesRouter.swift
//  Venues Demo
//
//  Created by Mohammad Shaker on 7/12/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import Foundation
import Alamofire
import Moya

enum VenuesRouter {
    case venues(latitude: Double, longitude: Double, limit: Int = 30, offset: Int = 0)
    case photos(venueId: String)
}

extension VenuesRouter: TargetType, CachePolicyGettable {
    
    var baseURL: URL {
        if let url = URL(string: Constants.BaseURL) {
            return url
        }
        fatalError("Venues Base URL Not Found")
    }
    
    var path: String {
        switch self {
        case .venues:
            return Constants.Services.VenuesExplore
        case .photos(let venueId):
            return String(format: Constants.Services.VenuesPhotos, venueId)
        }
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .venues(let latitude, let longitude, let limit, let offset):
            let params: [String: Any] = ["client_id": Constants.FourSquare.ClientID,
                          "client_secret": Constants.FourSquare.ClientSecret,
                          "ll": "\(latitude),\(longitude)",
                          "sortByDistance": true,
                          "offset": offset,
                          "limit": limit,
                          "v": Date().toString()
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .photos:
            let params: [String: Any] = ["client_id": Constants.FourSquare.ClientID,
                          "client_secret": Constants.FourSquare.ClientSecret,
                          "offset": 0,
                          "limit": 1,
                          "v": Date().toString()
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: [String: Any?]? {
        return nil
    }
}
