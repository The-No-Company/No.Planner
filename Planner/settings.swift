//
//  settings.swift
//  Planner
//
//  Created by Michael Safir on 13.10.2021.
//

import Foundation
import SwiftUI
import UIKit

func alert(title: String, message: String){
    UIApplication.shared.windows.first?.rootViewController?.present(alertView(title: title, message: message), animated: true)
}

private func alertView(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction (title: "Okey", style: UIAlertAction.Style.cancel, handler: nil)
    alert.addAction(okAction)
    
    return alert

}


func openSettings(title: String, message: String) {
    UIApplication.shared.windows.last?.rootViewController?.present(alertViewSettingsOpen(title: title, message: message), animated: true)
}

private func alertViewSettingsOpen(title: String, message: String) -> UIAlertController {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction (title: "Close", style: UIAlertAction.Style.cancel, handler: nil)
    alert.addAction(okAction)
    
    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                   return
               }

               if UIApplication.shared.canOpenURL(settingsUrl) {
                   UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                       print("Settings opened: \(success)") // Prints true
                   })
               }
           }

    alert.addAction(settingsAction)
    return alert

}

var SettingsAPI: Settings = Settings()

class Settings: ObservableObject, Identifiable {
    public var id: Int = 0
    public var shareURL : String = ""
    public var policy : String = ""
    public var feedback : String = ""
    public var terms : String = ""
    public var rate : String = ""

    
    func setupPushNotifications() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        requestPushNotificationsPermissions()
    }
    
    private func requestPushNotificationsPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if !granted || error != nil {
            } else {
                UserDefaults.standard.set(false, forKey: "didSetupPushNotifications")
                let center = UNUserNotificationCenter.current()
                center.removeAllDeliveredNotifications()
                center.removeAllPendingNotificationRequests()
                self.schedulePushNotifications()
            }
        }
    }
    
    private func schedulePushNotifications() {
        if UserDefaults.standard.bool(forKey: "didSetupPushNotifications") { return }
        
        if UserDefaults.standard.bool(forKey: "notifications") == false { return }
        
        PushNotification.allCases.forEach { (push) in
            let content = UNMutableNotificationContent()
            content.title = "No.Planner"
            content.body = push.rawValue
            content.sound = .default
            let trigger = UNCalendarNotificationTrigger(dateMatching: push.time, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let errorMessage = error?.localizedDescription {
                    print("NOTIFICATION ERROR: \(errorMessage)")
                } else {
                    UserDefaults.standard.set(true, forKey: "didSetupPushNotifications")
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    
}


enum PushNotification: String, CaseIterable {
    case morning = "Good morning, write down the tasks you have done."
    case noon = "A little time has passed and here we are again. Add tasks, please."
    case day = "Wow, it's time to write down what I'm doing."
    case evening = "How was your day? Write down everything that happened. "
    
    /// Hour of the day set in 24hours format
    var time: DateComponents {
        var components = DateComponents()
        switch self {
        case .morning:
            components.hour = 11
            components.minute = 25
        case .noon:
            components.hour = 14
            components.minute = 25
        case .day:
            components.hour = 17
            components.minute = 25
        case .evening:
            components.hour = 21
            components.minute = 25
        }
        return components
    }
}

var IconNamesAPI: IconNames = IconNames()


class IconNames: ObservableObject, Identifiable  {
    var iconNames: [String?] = [nil]
    //exact index we're at inside our icon names
    @Published var currentIndex = 0
    
    init() {
        getAlternateIconNames()
        
        if let currentIcon = UIApplication.shared.alternateIconName{
            self.currentIndex = iconNames.firstIndex(of: currentIcon) ?? 0
        }
    }
    
    func getAlternateIconNames(){
    //looking into our info.plist file to locate the specific Bundle with our icons
            if let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
                let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any]
            {
                     
                 for (_, value) in alternateIcons{
                    //Accessing the name of icon list inside the dictionary
                     guard let iconList = value as? Dictionary<String,Any> else{return}
                     //Accessing the name of icon files
                     guard let iconFiles = iconList["CFBundleIconFiles"] as? [String]
                         else{return}
                         //Accessing the name of the icon
                     guard let icon = iconFiles.first else{return}
                     iconNames.append(icon)
        
                 }
            }
    }
}

