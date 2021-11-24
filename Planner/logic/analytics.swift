//
//  File.swift
//  Planner
//
//  Created by Michael Safir on 25.11.2021.
//

import Foundation
import SwiftUI
import Alamofire
import SwiftyJSON

var AnalyticsAPI: Analytics = Analytics()

class Analytics: ObservableObject, Identifiable {
    public  var id: Int = 0
    private var server : String = "https://service.api.thenoco.co/analytics/"
    public  var application : String = "no.planner"
    public  var user : String = ""
    
    public func send(action: String){
        if (self.user != ""){
            AF.request("\(self.server)add", method: .post,
                       parameters: ["user_id" : self.user, "action" : action, "app" : self.application]).responseJSON { (response) in
                if (response.response?.statusCode == 200){
                    print("logs send success")
                }else{
                    print("logs send error with code: \(String(describing: response.response?.statusCode))")
                }
            }
        }
    }
    
    public func register(){

        if UserDefaults.standard.bool(forKey: "register") {
            let userDefaults = UserDefaults.standard.string(forKey: "user") ?? ""
            if (userDefaults == ""){
                print("error while user registration")
            }else{
                self.user = userDefaults
            }
            return
        }
        
        UserDefaults.standard.set(true, forKey: "icloud")
        UserDefaults.standard.set(true, forKey: "haptic")
        UserDefaults.standard.set(true, forKey: "notifications")

        SettingsAPI.setupPushNotifications()

        AF.request("\(self.server)register", method: .get, parameters: ["app" : self.application]).responseJSON { (response) in
            if (response.value != nil) {
                let json = JSON(response.value!)
                let user = json["user"].string!
                
                self.user = user
                UserDefaults.standard.set(user, forKey: "user")
                UserDefaults.standard.set(true, forKey: "register")
                
                self.send(action: "registration")
                
                print("user registration success \(self.user)")
            }
        }
    }
    
}
