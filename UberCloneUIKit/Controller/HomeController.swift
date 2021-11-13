//
//  HomeController.swift
//  UberCloneUIKit
//
//  Created by Caleb Danielsen on 13/11/2021.
//

import UIKit
import Firebase
import MapKit

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private let inputActionView = LocationInputActivationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        enableLocationServices()
        configureUI()
//        signOut()
    }
    
    // MARK: - API
    
    private func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
        } else {
             print("DEBUG: Already logged in...")
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Error Signing out")
        }
    }
    
    // MARK: - Helper functions
    
    private func configureUI() {
        view.backgroundColor = .black
        
        configureMapView()
        configureNavigationBar()
        
        view.addSubview(inputActionView)
        inputActionView.centerX(inView: view)
        inputActionView.setDimensions(height: 50, width: view.frame.width - 64)
        inputActionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
}

// MARK: - LocationsServices

extension HomeController: CLLocationManagerDelegate {
    private func enableLocationServices() {
        locationManager.delegate = self
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("DEBUG: Not determined")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("DEBUG: Auth always...")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: Auth when in use...")
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
    
    
    // Make sure that we ask the user if they want use "AlwaysAuthorization".
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
}
