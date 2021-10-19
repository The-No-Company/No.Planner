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
                        .font(.system(size: 30, weight: .medium, design: .rounded))
                        .foregroundColor(.black)
                }.frame(width: 45, height: 45, alignment: .center)
                    .padding(.trailing)
            })
                .buttonStyle(ScaleButtonStyle())
            
            
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: self.$showing_add) {
            AddView()
        }
        .onAppear{
            self.logic.getDate()
            self.logic.planner.getTasks()
            self.logic.initTimer()
            self.logic.getIconsDegaults()
            
        }
    }
}


