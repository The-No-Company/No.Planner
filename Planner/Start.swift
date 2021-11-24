//
//  ContentView.swift
//  Planner
//
//  Created by Michael Safir on 13.10.2021.
//

import SwiftUI

struct Start: View {
    @ObservedObject var logic: Logic = LogicAPI
    @ObservedObject var analytics: Analytics = AnalyticsAPI

    @State private var showing_add = false
    @State var open_type : Int = 0
    
    var body: some View {
        ZStack(alignment: .bottom){
            GeometryReader { proxy in
                
                let topEdge = proxy.safeAreaInsets.top
                
                HomeView(topEdge: topEdge)
                
                    .ignoresSafeArea(.all, edges: .top)
            }
            
            if #available(iOS 15.0, *) {
                HStack{
                    HStack{
                        Image(systemName: "clock")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .offset(y: -5)
                        
                        
                        Text("\(self.logic.getDateString())")
                            .font(Font.custom("Spectral-Medium", size: 20))
                            .offset(y: -5)
                    }.padding(.horizontal)
                    
                    Spacer()
                    Button(action: {
                        self.open_type = 0
                        self.showing_add.toggle()
                    }, label: {
                        ZStack{
                            Circle()
                                .fill(Color.white)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 30, weight: .medium, design: .rounded))
                                .foregroundColor(.black)
                        }
                        .frame(width: 45, height: 45, alignment: .center)
                        .padding()
                        
                        .clipped()
                        
                        
                        
                        
                    })
                        .offset(y: -5)
                        .contentShape(Rectangle())
                        .buttonStyle(ScaleButtonStyle())
                }
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                
            } else {
                HStack{
                    Image(systemName: "clock")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .offset(y: -5)
                    
                    Text("\(self.logic.getDateString())")
                        .font(Font.custom("Spectral-Medium", size: 26))
                        .padding(.horizontal)
                        .offset(y: -5)
                    
                    Spacer()
                    Button(action: {
                        
                        if (UserDefaults.standard.bool(forKey: "haptic")){
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                        }
                        
                        self.open_type = 0
                        self.showing_add.toggle()
                    }, label: {
                        ZStack{
                            Circle()
                                .fill(Color.white)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 30, weight: .medium, design: .rounded))
                                .foregroundColor(.black)
                        }
                        .frame(width: 45, height: 45, alignment: .center)
                        .padding()
                        
                        .clipped()
                        
                        
                        
                        
                    })
                        .offset(y: -5)
                        .contentShape(Rectangle())
                        .buttonStyle(ScaleButtonStyle())
                }
                .background(Color.black)
                .cornerRadius(16)
            }
            
            
            
            
        }
        .preferredColorScheme(.dark)
        .ignoresSafeArea(.all, edges: .bottom)
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: self.$showing_add) {
            if (self.open_type == 0){
                AddView()
            }
            
            if (self.open_type == 1){
                WelcomeView(close: self.$showing_add)
            }
        }
        .onAppear{
            
            SettingsAPI.setupPushNotifications()
            self.analytics.register()
            self.analytics.send(action: "open")
            
            
            self.logic.getDate()
            self.logic.planner.getTasks()
            self.logic.initTimer()
            self.logic.getIconsDegaults()
            
            let defaults = UserDefaults(suiteName: "group.thenoco.co.noplanner")
            
            let welcome = defaults!.object(forKey: "welcome") as? Bool ?? false
            if (welcome == false){
                defaults!.set(true, forKey: "welcome")
                self.open_type = 1
                self.showing_add.toggle()
            }
        }
    }
}


