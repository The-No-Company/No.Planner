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
            Start()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: "c6c8e30d-e1c2-4282-bff9-83838cb337a0")
        YMMYandexMetrica.activate(with: configuration!)
        
        return true
    }
    
}
