//
//  FirebaseManager.swift
//  Chats
//
//  Created by Brad Bomkamp on 2/27/23.
//
/**
 The code imports the Foundation, Firebase, and FirebaseStorage frameworks. It defines a class called FirebaseManager that inherits from NSObject.

 The FirebaseManager class has three properties: auth, storage, and firestore, which are instances of Auth, Storage, and Firestore, respectively. These properties will be used to authenticate the user, upload and download files to and from the Firebase Storage, and communicate with the Firestore database.

 The currentUser property is an optional ChatUser object that will store the currently logged in user.

 The class defines a static shared instance of FirebaseManager, which will allow for global access to the FirebaseManager object.

 The init() method configures the FirebaseApp, initializes the auth, storage, and firestore properties, and calls the superclass's init() method.
 */

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManager: NSObject {
    
    // Create instances of Firebase services
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    // Store the current user
    var currentUser: ChatUser?
    
    // Singleton pattern: create a shared instance of FirebaseManager
    static let shared = FirebaseManager()
    
    override init() {
        // Configure the Firebase app
        FirebaseApp.configure()
        
        // Set the Firebase service instances
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
    
}
