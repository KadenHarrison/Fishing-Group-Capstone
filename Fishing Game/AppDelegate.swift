//
//  AppDelegate.swift
//  Fishing Game
//
//  Created by Jane Madsen on 1/29/25.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        do {
//            let l1 = Location(name: "123", thumbnailName: "123", requiredLicense: .deepSea, requiredBoat: .canoe, availableFish: [.anglerfish, .bass])
//            l1.locationCaughtFish = LocationCaughtFish(location: l1, caughtFish: [.bass])
//            try SaveDataManager.shared.save([l1], forKey: "locations")
//        } catch {
//            print("Error saving data: \(error)")
//        }
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
}

