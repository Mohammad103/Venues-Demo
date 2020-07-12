//
//  Venue.swift
//  Venues Demo
//
//  Created by Mohammad Shaker on 7/12/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import Foundation
import ObjectMapper

struct Venue: Mappable {
    
    var id: String?
    var name: String?
    private var formattedAddress: [String]?
    var photo: VenuePhoto? // Local
    
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["venue.id"]
        name <- map["venue.name"]
        formattedAddress <- map["venue.location.formattedAddress"]
    }
    
    func address() -> String? {
        return formattedAddress?.joined(separator: ", ")
    }
}
