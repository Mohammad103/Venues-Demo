//
//  ViewController.swift
//  Venues Demo
//
//  Created by Mohammad Shaker on 7/12/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import UIKit
import CoreLocation

enum VenueLocationType {
    case singleUpdate
    case realtime
}

class VenuesViewController: BaseViewController {

    // MARK: - Outlets & UI
    @IBOutlet weak var typeBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl: UIRefreshControl?
    
    // MARK: - Properties
    private lazy var venuesViewModel = VenuesViewModel()
    private lazy var locationManager = CLLocationManager()
    private var latitude: Double?
    private var longitude: Double?
    private var locationType: VenueLocationType = .realtime
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        venuesViewModel.delegate = self
        setupUI()
        configureLocation()
    }
    
    
    // MARK: - Helpers
    private func configureLocation() {
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func addPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .defaultAppThemeColor
        tableView.refreshControl = refreshControl
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    private func setupUI() {
        addPullToRefresh()
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.shadowImage = UIImage()
        typeBarButton.setTitleTextAttributes([.font: UIFont.appFont(withSize: 14.0, andWeight: .regular)], for: .normal)
        typeBarButton.setTitleTextAttributes([.font: UIFont.appFont(withSize: 14.0, andWeight: .regular)], for: .selected)
    }
    
    @objc private func loadData() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                if let latitude = latitude, let longitude = longitude {
                    if venuesViewModel.numberOfVenues() == 0 {
                        showLoadingIndicator()
                    }
                    venuesViewModel.loadVenues(latitude: latitude, longitude: longitude)
                }
                
            default:
                break
            }
        }
    }
    
    private func updateCellImage(at index: Int) {
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? VenueTableViewCell {
            if let imageURL = venuesViewModel.thumbnailImageURL(at: index) {
                cell.configureCellImage(imageURL: imageURL)
            } else {
                venuesViewModel.loadVenueImages(at: index)
            }
        }
    }
    
    private func handleLocationSingleUpdate() {
        locationType = .singleUpdate
        typeBarButton.title = "Single Update"
        locationManager.stopUpdatingLocation()
    }
    
    private func handleLocationRealtime() {
        locationType = .realtime
        typeBarButton.title = "Realtime"
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Actions
    @IBAction func typeBarButtonTapped() {
        if locationType == .singleUpdate {
            handleLocationRealtime()
        } else {
            handleLocationSingleUpdate()
        }
    }
}


// MARK: - CLLocationManager Delegate Methods
extension VenuesViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            if locationType == .singleUpdate {
                locationManager.stopUpdatingLocation()
            }
            loadData()
        }
    }
}


// MARK: - Table View
extension VenuesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venuesViewModel.numberOfVenues()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VenueTableViewCell.cellId, for: indexPath) as! VenueTableViewCell
        if let venue = venuesViewModel.venue(at: indexPath.row) {
            cell.configureCell(venue: venue)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let imageURL = venuesViewModel.thumbnailImageURL(at: indexPath.row) {
            (cell as? VenueTableViewCell)?.configureCellImage(imageURL: imageURL)
        } else {
            venuesViewModel.loadVenueImages(at: indexPath.row)
        }
    }
}


// MARK: - VenuesViewModel Delegate
extension VenuesViewController: VenuesViewModelDelegate {
    func venuesLoadedSuccessfully() {
        refreshControl?.endRefreshing()
        hideLoadingIndicator()
        tableView.reloadData()
    }
    
    func venuesFailedWithError(errorMessage: String) {
        refreshControl?.endRefreshing()
        hideLoadingIndicator()
        showError(withMessage: errorMessage)
    }
    
    func venueImagesLoadedSuccessfully(at index: Int) {
        updateCellImage(at: index)
    }
    
    func venueImagesFailedWithError(errorMessage: String) {
        showError(withMessage: errorMessage)
    }
}
