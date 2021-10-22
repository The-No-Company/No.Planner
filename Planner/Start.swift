//
//  ContentView.swift
//  Planner
//
//  Created by Michael Safir on 13.10.2021.
//

import SwiftUI

struct Start: View {
    @ObservedObject var logic: Logic = LogicAPI

    @State private var showing_add = false
    @State var open_type : Int = 0

    var body: some View {
        ZStack(alignment: .bottomTrailing){
            GeometryReader { proxy in
                
                let topEdge = proxy.safeAreaInsets.top
                
                HomeView(topEdge: topEdge)
                    .ignoresSafeArea(.all, edges: .top)
            }
            
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
                }.frame(width: 45, height: 45, alignment: .center)
                    .padding(.trailing)
            })
                .buttonStyle(ScaleButtonStyle())
            
            
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: self.$showing_add) {
            if (self.open_type == 0){
                AddView()
            }
            
            if (self.open_type == 1){
                WelcomeView(close: self.$showing_add)
            }
        }
        .onAppear{
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


