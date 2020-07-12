//
//  VenuePhoto.swift
//  Venues Demo
//
//  Created by Mohammad Shaker on 7/12/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import Foundation
import ObjectMapper

struct VenuePhoto: Mappable {
    
    var id: String?
    var prefix: String?
    var suffix: String?
    var width: Int?
    var height: Int?
    
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["venue.id"]
        prefix <- map["prefix"]
        suffix <- map["suffix"]
        width <- map["width"]
        height <- map["height"]
    }
    
    func thumbnailURL() -> String? {
        if prefix == nil || suffix == nil {
            return nil
        }
        let imageSize = "cap100"
        return prefix! + imageSize + suffix!
    }
}
