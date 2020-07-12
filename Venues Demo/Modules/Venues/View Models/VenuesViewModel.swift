//
//  VenuesViewModel.swift
//  Venues Demo
//
//  Created by Mohammad Shaker on 7/12/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import Foundation
import ObjectMapper

protocol VenuesViewModelDelegate: class {
    func venuesLoadedSuccessfully()
    func venuesFailedWithError(errorMessage: String)
    func venueImagesLoadedSuccessfully(at index: Int)
    func venueImagesFailedWithError(errorMessage: String)
}

class VenuesViewModel {
    
    // MARK: - Properties
    private var venuesResponse: VenuesResponse?
    weak var delegate: VenuesViewModelDelegate?
    
    
    // MARK: - Load data methods
    func loadVenues(latitude: Double, longitude: Double) {
        RequestManager.beginRequest(withTargetType: VenuesRouter.self, andTarget: VenuesRouter.venues(latitude: latitude, longitude: longitude), responseModel: VenuesResponse.self) { [weak self] (data, error) in
            guard let weakSelf = self else { return }
            if error != nil {
                weakSelf.delegate?.venuesFailedWithError(errorMessage: error!.errorMessage)
                return
            }
            
            if let response = data as? VenuesResponse {
                weakSelf.venuesResponse = response
                weakSelf.delegate?.venuesLoadedSuccessfully()
            } else {
                weakSelf.delegate?.venuesFailedWithError(errorMessage: "ERR701 - Error happened while trying to load venues")  // ERR701 for parsing
            }
        }
    }
    
    func loadVenueImages(at index: Int) {
        #warning("Simulation Code!")
        return
        
        guard let venueId = venuesResponse?.venues?[index].id else { return }
        
        RequestManager.beginRequest(withTargetType: VenuesRouter.self, andTarget: VenuesRouter.photos(venueId: venueId), responseModel: VenuePhotosResponse.self) { [weak self] (data, error) in
            guard let weakSelf = self else { return }
            if error != nil {
                weakSelf.delegate?.venueImagesFailedWithError(errorMessage: error!.errorMessage)
                return
            }
            
            if let response = data as? VenuePhotosResponse {
                if (response.photos?.count ?? 0) > 0 {
                    weakSelf.venuesResponse?.venues?[index].photo = response.photos?[0]
                }
                weakSelf.delegate?.venueImagesLoadedSuccessfully(at: index)
            } else {
                weakSelf.delegate?.venueImagesFailedWithError(errorMessage: "ERR701 - Error happened while trying to load venue images")  // ERR701 for parsing
            }
        }
    }
    
    
    // MARK:- Datasource methods
    func numberOfVenues() -> Int {
        return venuesResponse?.venues?.count ?? 0
    }
    
    func venue(at index: Int) -> Venue? {
        return venuesResponse?.venues?[index]
    }
    
    func title(at index: Int) -> String? {
        return venuesResponse?.venues?[index].name
    }
    
    func address(at index: Int) -> String? {
        return venuesResponse?.venues?[index].address()
    }
    
    func thumbnailImageURL(at index: Int) -> String? {
        return venuesResponse?.venues?[index].photo?.thumbnailURL()
    }
    
    func isFirstLoading() -> Bool {
        if venuesResponse == nil {
            return true
        }
        return false
    }
}
