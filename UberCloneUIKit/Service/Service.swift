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
    let REF_TRIPS = Database.database().reference().child("trips")
    
    static var shared = Service()
    
    private init() {}
    
    mutating func fetchUserData(uid: String, completion: @escaping(User) -> Void) {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let suid = snapshot.key
            let user = User(uid: suid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchDrivers(location: CLLocation, completion: @escaping(User) -> Void) {
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        
        REF_DRIVER_LOCATIONS.observe(.value) { (snapshot) in
            
            geofire.query(at: location, withRadius: 50).observe(.keyEntered, with: { (uid, location) in
                Service.shared.fetchUserData(uid: uid, completion: { (user) in
                    var driver = user
                    driver.location = location
                    completion(driver)
                })
            })
        }
    }
    
    func uploadTrip(_ pickupCoordinates: CLLocationCoordinate2D, _ destinationCoordinates: CLLocationCoordinate2D, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let pickupArray = [pickupCoordinates.latitude, pickupCoordinates.longitude]
        let destinationArray = [destinationCoordinates.latitude, destinationCoordinates.longitude]
        
        let values = [
            "pickupCoordinates": pickupArray,
            "destinationCoordinates": destinationArray,
            "state": TripState.requested.rawValue
        ] as [String : Any]
        REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func observeTrips(completion: @escaping(Trip) -> Void) {
        REF_TRIPS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            print("DEBUG: Dictionary \(dictionary)")
            
            let uid = snapshot.key
            let trip = Trip(passengerUid: uid, dictionary: dictionary)
            print("DEBUG: Trip state is\(trip.state)")
            completion(trip)
        }
    }
}
