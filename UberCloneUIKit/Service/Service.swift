//
//  Service.swift
//  UberCloneUIKit
//
//  Created by Caleb Danielsen on 15/11/2021.
//
// Using the singleton pattern

import Firebase

struct Service {
    
    let REF_USERS = Database.database().reference().child("users")
    let REF_DRIVER_LOCATIONS = Database.database().reference().child("driver-locations")
    
    static var shared = Service()
    
    private init() {}
    
    mutating func fetchUserData(completion: @escaping(User) -> Void) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
             let user = User(dictionary: dictionary)
            completion(user)
        }
    }
}
