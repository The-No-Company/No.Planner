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

