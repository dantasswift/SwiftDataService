//
//  SwiftDataServiceApp.swift
//  SwiftDataService
//
//  Created by Fabio Dantas on 27/11/2025.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        do {
            try DatabaseService.shared.setup(name: "service_db")
        } catch {
            print("Uable to initialise Database: \(error.localizedDescription)")
        }
        return true
    }
}

@main
struct SwiftDataServiceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
