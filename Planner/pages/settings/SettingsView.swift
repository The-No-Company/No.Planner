//
//  SettingsView.swift
//  Planner
//
//  Created by Michael Safir on 14.10.2021.
//

import SwiftUI
import WidgetKit
import Combine

struct SettingsView: View {
    
    @ObservedObject var logic: Logic = LogicAPI
    
    @State var none : String = ""
    @State var green : String = ""
    @State var blue : String = ""
    @State var orange : String = ""
    @State var red : String = ""
    @State var purple : String = ""
    
    @Binding var close : Bool
    @State private var selectedColor = Color.white
    
    @State  var icloud : Bool = true
    @State  var haptic : Bool = true
    @State  var notifications : Bool = true
    
  
    
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 10){
                    //                    Block with information
                    VStack(spacing: 10){
                        HStack{
                            Text("Settings. 🥳")
                                .font(Font.custom("Spectral-Medium", size: 26))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        HStack{
                            Text("Customize the app to fit your needs. Add the tags you use in your daily life, specify the colors you like and customize the widget to your liking!")
                                .font(.custom("SourceCodePro-Regular", size: 14))
                                .foregroundColor(Color.secondary.opacity(0.7))
                            
                            Spacer()
                        } .padding(.horizontal, 20)
                        
                    }.padding(.top)
                    //                    Block with information END
                    
                    VStack(spacing: 10){
                        HStack{
                            Text("General")
                                .font(Font.custom("Spectral-Medium", size: 20))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.secondary.opacity(0.2))
                            .padding(.horizontal, 20)
                            .frame(height: 2)
                        
                    }
                    .padding(.bottom, 10)
                    
                    
                    VStack(spacing: 0){
                        HStack{
                            Text("Use Haptic Feedback")
                                .font(.custom("SourceCodePro-Regular", size: 14))
                                .fixedSize()
                            
                            Spacer()
                            
                            
                            if #available(iOS 15.0, *) {
                                Toggle("", isOn: $haptic)
                                    .tint(Color.white)
                            } else {
                                Toggle("", isOn: $haptic)
                                    .accentColor(Color.white)
                            }
                            
                        }.onChange(of: Just(self.haptic)) { result in
                            print("Haptic - \(self.haptic)")
                            UserDefaults.standard.set(self.haptic, forKey: "haptic")
                            
                            if (self.haptic){
                                AnalyticsAPI.send(action: "settings_haptic_true")
                            }else{
                                AnalyticsAPI.send(action: "settings_haptic_false")
                            }
                        }
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.secondary.opacity(0.2))
                            .frame(height: 2)
                            .padding(.vertical, 10)
                        
                        HStack{
                            Text("Notifications")
                                .font(.custom("SourceCodePro-Regular", size: 14))
                                .fixedSize()
                            
                            Spacer()
                            
                            if #available(iOS 15.0, *) {
                                Toggle("", isOn: $notifications)
                                    .tint(Color.white)
                            } else {
                                Toggle("", isOn: $notifications)
                                    .accentColor(Color.white)
                            }
                            
                        }.onChange(of: Just(self.notifications)) { result in
                            print("Notifications - \(self.notifications)")
                            UserDefaults.standard.set(self.notifications, forKey: "notifications")
                            
                            if (self.notifications == false){
                                let center = UNUserNotificationCenter.current()
                                center.removeAllDeliveredNotifications()
                                center.removeAllPendingNotificationRequests()
                            }
                            
                            if (self.notifications == true){
                                SettingsAPI.setupPushNotifications()
                            }
                            
                            if (self.notifications){
                                AnalyticsAPI.send(action: "settings_notifications_true")
                            }else{
                                AnalyticsAPI.send(action: "settings_notifications_false")
                            }
                            
                        }
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.secondary.opacity(0.2))
                            .frame(height: 2)
                            .padding(.vertical, 10)
                        
                        HStack{
                            Text("iCloud Sync and Backup")
                                .font(.custom("SourceCodePro-Regular", size: 14))
                                .fixedSize()
                            
                            Spacer()
                            
                            if #available(iOS 15.0, *) {
                                Toggle("", isOn: $icloud)
                                    .tint(Color.white)
                            } else {
                                Toggle("", isOn: $icloud)
                                    .accentColor(Color.white)
                            }
                            
                        }.onChange(of: Just(self.icloud)) { result in
                            print("iCloud - \(self.icloud)")
                            UserDefaults.standard.set(self.icloud, forKey: "icloud")
                            
                            if (self.notifications){
                                AnalyticsAPI.send(action: "settings_icloud_true")
                            }else{
                                AnalyticsAPI.send(action: "settings_icloud_false")
                            }
                            
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.init(hex: "2A2A2A"))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    
                    
                    VStack(spacing: 10){
                        HStack{
                            Text("Tags")
                                .font(Font.custom("Spectral-Medium", size: 20))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.secondary.opacity(0.2))
                            .padding(.horizontal, 20)
                            .frame(height: 2)
                        
                    }.padding(.bottom, 10)
                    
                    VStack(spacing: 10){
                        HStack(spacing: 5){
                            
                            Button(action: {
                                
                            }, label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.init(hex: "2ECC71"))
                                }
                                .frame(width: 30, height: 30)
                            }).buttonStyle(ScaleButtonStyle())
                            
                            
                            Spacer()
                            
                            SearchBarView(text: self.$green, title: self.logic.getIcon(name: "green"), image: "tag", type: .webSearch)
                            
                        }
                        
                        HStack(spacing: 5){
                            
                            Button(action: {
                                
                            }, label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.init(hex: "3498DB"))
                                }
                                .frame(width: 30, height: 30)
                            }).buttonStyle(ScaleButtonStyle())
                            
                            
                            Spacer()
                            
                            SearchBarView(text: self.$blue, title: self.logic.getIcon(name: "blue"), image: "tag", type: .webSearch)
                            
                        }
                        
                        HStack(spacing: 5){
                            
                            Button(action: {
                                
                            }, label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.init(hex: "E74C3C"))
                                }
                                .frame(width: 30, height: 30)
                            }).buttonStyle(ScaleButtonStyle())
                            
                            
                            Spacer()
                            
                            SearchBarView(text: self.$red, title: self.logic.getIcon(name: "red"), image: "tag", type: .webSearch)
                            
                        }
                        
                        HStack(spacing: 5){
                            
                            Button(action: {
                                
                            }, label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.init(hex: "F39C12"))
                                }
                                .frame(width: 30, height: 30)
                            }).buttonStyle(ScaleButtonStyle())
                            
                            
                            Spacer()
                            
                            SearchBarView(text: self.$orange, title: self.logic.getIcon(name: "orange"), image: "tag", type: .webSearch)
                            
                        }
                        
                        HStack(spacing: 5){
                            
                            Button(action: {
                                
                            }, label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.init(hex: "9B59B6"))
                                }
                                .frame(width: 30, height: 30)
                            }).buttonStyle(ScaleButtonStyle())
                            
                            
                            Spacer()
                            
                            SearchBarView(text: self.$purple, title: self.logic.getIcon(name: "purple"), image: "tag", type: .webSearch)
                            
                        }
                        
                    }.padding(.horizontal, 20)
                    
                    VStack(spacing: 10){
                        HStack{
                            Text("Widget color")
                                .font(Font.custom("Spectral-Medium", size: 20))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.secondary.opacity(0.2))
                            .padding(.horizontal, 20)
                            .frame(height: 2)
                        
                    }.padding(.bottom, 10)
                    
                    VStack(spacing: 10){
                        
                        HStack{
                            ColorPicker(
                                "Select",
                                selection: $selectedColor
                            )
                            
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(self.selectedColor)
                                .frame(height: 25)
                            
                        }
                        
                    }.padding(.horizontal, 20)
                    //
                    
                    
                    Spacer()
                    
                    
                }
            }
            
            Button(action: {
                
                self.logic.types["red"] = self.red
                self.logic.types["blue"] = self.blue
                self.logic.types["green"] = self.green
                self.logic.types["orange"] = self.orange
                self.logic.types["purple"] = self.purple
                
                let defaults = UserDefaults(suiteName: "group.thenoco.co.noplanner")
                defaults!.set(self.logic.types, forKey: "types")
                
                let ui_color = self.selectedColor.uiColor()
                defaults!.widgetColor = ui_color
                
                
                WidgetCenter.shared.reloadAllTimelines()
                
                self.close.toggle()
                
                
            }, label: {
                Text("save settings")
                    .padding(.horizontal, 35)
                    .padding(.vertical, 5)
                    .background(Color.white)
                    .cornerRadius(8.0)
                    .foregroundColor(Color.black)
                    .font(Font.custom("Spectral-Medium", size: 16))
            }).buttonStyle(ScaleButtonStyle())
                .padding(.bottom)
            
        }.onAppear{
            self.red = self.logic.getIcon(name: "red")
            self.green = self.logic.getIcon(name: "green")
            self.blue = self.logic.getIcon(name: "blue")
            self.orange = self.logic.getIcon(name: "orange")
            self.purple = self.logic.getIcon(name: "purple")
            
            let defaults = UserDefaults(suiteName: "group.thenoco.co.noplanner")
            self.selectedColor = defaults!.widgetColor?.suColor ?? Color.init(hex: "ffffff")
            
            UISwitch.appearance().thumbTintColor = UIColor.black.withAlphaComponent(0.85)
            
        }
    }
}

