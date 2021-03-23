//
//  MainMapViewController.swift
//  AcceloTest
//
//  Created by Serhii Semenov on 14.08.2020.
//  Copyright © 2020 Serhii Semenov. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps
import RxSwift
import RxCocoa

class MainMapViewController: UIViewController, Alertable {

    // MARK: - IBOutlets
    @IBOutlet weak var crimeDialogView: CrimeDialog!
    
    // MARK: - Properties
    private let viewModel = MainMapViewModel()
    private var googleMapView: GMSMapView!
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureVM()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        
        self.configureMapView()
    }
    
    private func configureMapView() {
        
        let lat = MainMapViewControllerConstants.londonLat
        let lng = MainMapViewControllerConstants.londonLong
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 14.0)
        self.googleMapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.googleMapView.delegate = self
        self.googleMapView.settings.consumesGesturesInView = false
        self.view.insertSubview(googleMapView, at: 0)
    }
    
    //MARK: - Configure VM
    private func configureVM() {
        
        self.viewModel.crimes
            .bind { [weak self] in self?.createMarker(crimes: $0) }
            .disposed(by: disposeBag)
        self.viewModel.alertWithMessage
            .bind { [weak self] in self?.displayError($0) }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    private func createMarker(crimes: Crimes) {
        
        self.googleMapView.clear()
        
        for crime in crimes {
            
            let coordinate = CLLocationCoordinate2D(latitude: crime.location.latitude,
                                                    longitude: crime.location.longitude)
            
            let marker = GMSMarker()
            marker.position = coordinate
            marker.title = crime.category
            marker.userData = crime
            marker.map = googleMapView
        }
    }
}

// MARK: Extensions
extension MainMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        guard let userData = marker.userData as? Crime else { return Bool() }
        
        let category = userData.category
        let crimeLocation = userData.location.street.name
        
        crimeDialogView.configureView(crimeCategory: category, crimeLocation: crimeLocation)
        
        crimeDialogView.passingCloseButtonData = {
            self.crimeDialogView.isHidden = true
        }
        
        self.crimeDialogView.isHidden = false
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        let searchedLocation = SearchedLocation(latitude: position.target.latitude,
                                                Longitude: position.target.longitude,
                                                date: MainMapViewControllerConstants.date)
        
        self.viewModel.getCrimesAt(searchedLocation: searchedLocation)
    }
}
