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
        
        
        if (UserDefaults.standard.bool(forKey: "icloud")){
            RealmAPI.synciCloud()
        }else{
            if !UserDefaults.standard.bool(forKey: "register") {
                
                UserDefaults.standard.set(true, forKey: "icloud")
                UserDefaults.standard.set(true, forKey: "haptic")
                UserDefaults.standard.set(true, forKey: "notifications")
                
                RealmAPI.synciCloud()
            }
        }
        
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: "c6c8e30d-e1c2-4282-bff9-83838cb337a0")
        YMMYandexMetrica.activate(with: configuration!)
        
        return true
    }
    
}
