//
//  Service.swift
//  UberCloneUIKit
//
//  Created by Caleb Danielsen on 15/11/2021.
//
// Using the singleton pattern

import Firebase
import GeoFire

struct Service {
    
    let REF_USERS = Database.database().reference().child("users")
    let REF_DRIVER_LOCATIONS = Database.database().reference().child("driver-locations")
    
    static var shared = Service()
    
    private init() {}
    
    mutating func fetchUserData(uid: String, completion: @escaping(User) -> Void) {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
             let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchDrivers(location: CLLocation, completion: @escaping(User) -> Void) {
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        
        REF_DRIVER_LOCATIONS.observe(.value) { (snapshot) in
            geofire.query(at: location, withRadius: 50).observe(.keyEntered, with: { (uid, location) in
                Service.shared.fetchUserData(uid: uid, completion: { (user) in
                    completion(user)
                })
            })
        }
    }
}
