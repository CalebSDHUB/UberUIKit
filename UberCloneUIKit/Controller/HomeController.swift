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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
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
    
    func configureUI() {

        view.backgroundColor = .red
        
        view.addSubview(mapView)
        mapView.frame = view.frame
    }
}
