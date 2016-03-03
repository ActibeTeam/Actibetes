//
//  FirebaseDataService.swift
//  Actibetes
//
//  Created by Sarah-Jessica Jemitola on 02/03/2016.
//  Copyright © 2016 mobilehealthcareinc. All rights reserved.
//

import Foundation
import Firebase
class FirebaseDataService {
    static let dataService = FirebaseDataService()
    //FIREBASE_ROOT_URL defined in Constants.swift file
    private var BASE_REF = Firebase(url: "\(FIREBASE_ROOT_URL)")
    private var USER_REF = Firebase(url: "\(FIREBASE_ROOT_URL)/users")
    
    
    var rootReference: Firebase {
        return BASE_REF
    }
    
    var userReference: Firebase {
        return USER_REF
    }
    
    var currentUserReference: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        let currentUser = userReference.childByAppendingPath(userID)
        
        return currentUser!
    }
    
    func createNewUserAccount(uid: String, user: [String:String]){
        currentUserReference.setValue(user)
    }
    
    func addNewActibetesEntry(dict: [String:AnyObject], uid: String){
        currentUserReference.childByAppendingPath("actibetesEntry").childByAutoId().setValue(dict)
    }
    
}