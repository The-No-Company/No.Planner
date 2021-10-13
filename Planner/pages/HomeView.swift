//
//  HomeView.swift
//  Planner
//
//  Created by Michael Safir on 13.10.2021.
//

import SwiftUI

struct HomeView: View {
    @State private var showing_add = false
    
    init(){
        let apparence = UITabBarAppearance()
        apparence.configureWithOpaqueBackground()
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = apparence
        }
    }
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                Text("Explore")
                    .font(Font.custom("Spectral-Medium", size: 26))
                Spacer()
                
                Button(action: {
                    self.showing_add.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                })
                    .padding(.trailing, 10)
                
                Button(action: {
                    
                    
                }, label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                })
            }
            .padding(.horizontal, 10)
            
            ScrollView(.vertical, showsIndicators: false){
                Spacer()
            }
            
        }.sheet(isPresented: self.$showing_add) {
            AddView()
        }
    }
}

