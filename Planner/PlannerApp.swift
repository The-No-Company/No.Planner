//
//  PlannerApp.swift
//  Planner
//
//  Created by Michael Safir on 13.10.2021.
//

import SwiftUI
import UIKit
import YandexMobileMetrica
import YandexMobileMetricaPush

//c6c8e30d-e1c2-4282-bff9-83838cb337a0

@main
struct PlannerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            Test()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: "c6c8e30d-e1c2-4282-bff9-83838cb337a0")
        YMMYandexMetrica.activate(with: configuration!)
        
        if #available(iOS 10.0, *) {
            // iOS 10.0 and above.
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
        } else {
            // iOS 8 and iOS 9.
            let settings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        #if DEBUG
            let pushEnvironment = YMPYandexMetricaPushEnvironment.development
        #else
            let pushEnvironment = YMPYandexMetricaPushEnvironment.production
        #endif
        YMPYandexMetricaPush.setDeviceTokenFrom(deviceToken, pushEnvironment: pushEnvironment)
    }
}
