//
//  VenuePhotosResponse.swift
//  Venues Demo
//
//  Created by Mohammad Shaker on 7/12/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import Foundation
import ObjectMapper

struct VenuePhotosResponse: Mappable {
    
    var count: Int?
    var photosList: [VenuePhoto]?
    
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        photosList <- map["response.photos.items"]
        count <- map["response.photos.count"]
    }
}
