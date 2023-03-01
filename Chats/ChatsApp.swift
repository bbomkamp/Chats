//
//  ChatsApp.swift
//  Chats
//
//  Created by Brad Bomkamp on 2/24/23.
//

// This code imports the SwiftUI framework and the FirebaseCore framework.
import SwiftUI
import FirebaseCore

// This code defines a class called "AppDelegate" that conforms to the "UIApplicationDelegate" protocol.
class AppDelegate: NSObject, UIApplicationDelegate {
    
    // A function that is called when the application finishes launching.
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Returns true to indicate that the application has finished launching.
        return true
    }
}

// This code defines a struct called "ChatsApp" that conforms to the "App" protocol in SwiftUI.
@main
struct ChatsApp: App {
    
    // An instance of the "AppDelegate" class.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // The body of the "ChatsApp" struct, which defines the structure and behavior of the app.
    var body: some Scene {
        // A window group that contains the app's main user interface.
        WindowGroup {
            // The initial view that the user sees when the app is launched.
            MainMessagesView()
        }
    }
}
