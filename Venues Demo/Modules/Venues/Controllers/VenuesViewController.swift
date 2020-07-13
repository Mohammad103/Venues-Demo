//
//  ViewController.swift
//  Venues Demo
//
//  Created by Mohammad Shaker on 7/12/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import UIKit
import CoreLocation
import DZNEmptyDataSet
import RevealingSplashView

enum VenueLocationType {
    case singleUpdate
    case realtime
}

class VenuesViewController: BaseViewController {

    // MARK: - Static
    private let kMinimumMetersDistanceToUpdate = 500.0
    
    // MARK: - Outlets & UI
    @IBOutlet weak var typeBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl: UIRefreshControl?
    
    // MARK: - Properties
    private lazy var venuesViewModel = VenuesViewModel()
    private lazy var locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D?
    private var locationType: VenueLocationType = .realtime
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        venuesViewModel.delegate = self
        setupAnimatedSplashScreen()
        setupUI()
        configureLocation()
    }
    
    
    // MARK: - Helpers
    private func setupAnimatedSplashScreen() {
        let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "radar"), iconInitialSize: CGSize(width: 125, height: 125), backgroundColor: UIColor.defaultAppThemeColor)
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        keyWindow?.addSubview(revealingSplashView)
        revealingSplashView.startAnimation()
    }
    
    private func configureLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        startUpdatingLocation()
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
                if let location = currentLocation {
                    if venuesViewModel.isFirstLoading() {
                        showLoadingIndicator()
                    }
                    venuesViewModel.loadVenues(latitude: location.latitude, longitude: location.longitude)
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
    
    private func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
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
        startUpdatingLocation()
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
        if locationType == .singleUpdate {
            locationManager.stopUpdatingLocation()
        }
        
        if let location = locations.last {
            if venuesViewModel.isFirstLoading() {
                currentLocation = location.coordinate
                loadData()
            } else if currentLocation != nil, abs(location.coordinate.distance(from: currentLocation!)) > kMinimumMetersDistanceToUpdate {
                currentLocation = location.coordinate
                loadData()
            }
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
        if (tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false) {
            if let imageURL = venuesViewModel.thumbnailImageURL(at: indexPath.row) {
                cell.configureCellImage(imageURL: imageURL)
            } else {
                venuesViewModel.loadVenueImages(at: indexPath.row)
            }
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
        tableView.emptyDataSetSource = self
        refreshControl?.endRefreshing()
        hideLoadingIndicator()
        tableView.reloadData()
    }
    
    func venuesFailedWithError(errorMessage: String) {
        tableView.emptyDataSetSource = self
        refreshControl?.endRefreshing()
        hideLoadingIndicator()
        tableView.reloadData()
    }
    
    func venueImagesLoadedSuccessfully(at index: Int) {
        updateCellImage(at: index)
    }
    
    func venueImagesFailedWithError(errorMessage: String) {
        showError(withMessage: errorMessage)
    }
}


// MARK: - DZNEmptyDataSet Source & Delegate methods
extension VenuesViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if venuesViewModel.shouldShowError() {
            return #imageLiteral(resourceName: "error")
        }
        return #imageLiteral(resourceName: "warning")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var text = "No data found !!"
        if venuesViewModel.shouldShowError() {
            text = "Something went wrong !!"
        }
        let attributes: [NSAttributedString.Key : Any] = [.font: UIFont.appFont(withSize: 16, andWeight: .regular),
                                                          .foregroundColor: UIColor.black]
        return NSAttributedString(string: text, attributes: attributes)
    }
}
