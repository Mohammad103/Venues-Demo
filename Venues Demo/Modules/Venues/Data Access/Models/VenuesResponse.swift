//
//  VenuesResponse.swift
//  Venues Demo
//
//  Created by Mohammad Shaker on 7/12/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import Foundation
import ObjectMapper

struct VenuesResponse: Mappable {
    
    var totalResults: Int?
    var venues: [Venue]?
    
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        venues <- map["response.groups.0.items"]
        totalResults <- map["response.totalResults"]
    }
}
