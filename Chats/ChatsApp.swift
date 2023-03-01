//
//  ChatsApp.swift
//  Chats
//
//  Created by Brad Bomkamp on 2/24/23.
//

// This code imports the SwiftUI framework and the FirebaseCore framework.
import SwiftUI
import FirebaseCore

import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UIApplicationDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Initialize the window with the scene's UIWindowScene
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        
        // Set the background color of the window
        window?.backgroundColor = UIColor(named: "white")
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let splashScreenView = SplashScreenView()
        let rootView = UIHostingController(rootView: splashScreenView)
        window?.rootViewController = rootView
        window?.makeKeyAndVisible()
        return true
    }

}


// ChatsApp.swift

@main
struct ChatsApp: App {
    @UIApplicationDelegateAdaptor(SceneDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
