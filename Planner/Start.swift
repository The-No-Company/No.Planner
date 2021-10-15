//
//  ContentView.swift
//  Planner
//
//  Created by Michael Safir on 13.10.2021.
//

import SwiftUI

struct Start: View {
    @ObservedObject var logic: Logic = LogicAPI
    
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var showing_add = false

    var body: some View {
        ZStack(alignment: .bottomTrailing){
            HomeView()
            
            Button(action: {
                self.showing_add.toggle()
            }, label: {
                ZStack{
                    Circle()
                        .fill(Color.white)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.black)
                }.frame(width: 35, height: 35, alignment: .center)
            })
                .buttonStyle(ScaleButtonStyle())
                .padding()
            
            
        }
        .preferredColorScheme(.dark)
//        .onReceive(timer) { input in
//            self.logic.objectWillChange.send()
//            self.logic.getDate()
//        }
        .sheet(isPresented: self.$showing_add) {
            AddView()
        }
        .onAppear{
            self.logic.getDate()
            self.logic.planner.getTasks()
            self.logic.initTimer()
            
        }
    }
}

