//
//  Connectivity.swift
//  Venues Demo
//
//  Created by Mohammad Shaker on 7/12/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    
    private let manager = NetworkReachabilityManager(host: "www.google.com")
    static let shared: Connectivity = { return Connectivity() }()
    
    
    func isConnectedToInternet() -> Bool {
        return manager?.isReachable ?? false
    }
}
