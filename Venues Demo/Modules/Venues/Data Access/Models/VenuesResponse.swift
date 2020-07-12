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
    var venuesList: [Venue]?
    
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        venuesList <- map["response.groups.items"]
        totalResults <- map["response.totalResults"]
    }
}
