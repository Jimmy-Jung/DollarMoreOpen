//
//  AppDelegate.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/11.
//

import UIKit
import SwiftRater
import GoogleMobileAds
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // GoogleMobileAds
        GADMobileAds.sharedInstance().start()
        FirebaseApp.configure()
        // SwiftRater
        fetchSwiftRater()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    
    private func fetchSwiftRater() {
        SwiftRater.daysUntilPrompt = 1
        SwiftRater.usesUntilPrompt = 0
        SwiftRater.significantUsesUntilPrompt = 0
        SwiftRater.daysBeforeReminding = 1
        SwiftRater.showLaterButton = true
        SwiftRater.debugMode = false
        SwiftRater.appLaunched()
    }
    
    


}

