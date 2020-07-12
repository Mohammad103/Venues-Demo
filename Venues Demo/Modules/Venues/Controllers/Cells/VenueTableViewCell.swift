//
//  VenueTableViewCell.swift
//  Venues Demo
//
//  Created by Mohammad Shaker on 7/12/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import UIKit
import Kingfisher

class VenueTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let cellId = "VenueTableViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    // MARK: - Setup
    func configureCell(venue: Venue) {
        titleLabel.text = venue.name
        addressLabel.text = venue.address()
        
        if let urlStr = venue.photo?.thumbnailURL() {
            configureCellImage(imageURL: urlStr)
        }
    }
    
    func configureCellImage(imageURL: String) {
        if let url = URL(string: imageURL) {
            thumbnailImageView.kf.indicatorType = .activity
            thumbnailImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder"))
        }
    }
}
