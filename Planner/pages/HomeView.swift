//
//  HomeView.swift
//  Planner
//
//  Created by Michael Safir on 13.10.2021.
//

import SwiftUI

struct HomeView: View {
    @State private var showing_add = false
    @ObservedObject var logic: Logic = LogicAPI
    
    @SwiftUI.Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    
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
                Text("\(self.logic.date_string)")
                    .font(Font.custom("Spectral-Medium", size: 26))
                Spacer()
                
                Button(action: {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    
                    self.showing_add.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                })
                    .padding(.trailing, 10)
                
            }
            .padding(.horizontal, 10)
            
            if (self.logic.planner.tasks.count == 0){
                
                Spacer()
                VStack(spacing: 10){
                    Text("No.Tasks")
                        .font(.custom("SourceCodePro-Regular", size: 16))
                        .foregroundColor(Color.secondary.opacity(0.7))
                    
                    Text("\(self.logic.time_string)")
                        .font(Font.custom("Spectral-Medium", size: 32))
                }
                
                Spacer()
            }else{
                ScrollView(.vertical, showsIndicators: false){
                    ForEach(self.logic.planner.tasks.reversed(), id: \.self){ task in
                        TaskView(id: task.id, text: task.text, time: task.display_date, tags_array: task.tags)
                    }
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal, 10)
            }
            
            
        }.sheet(isPresented: self.$showing_add) {
            AddView()
        }
        .onAppear{
            self.logic.planner.getTasks()
        }
    }
}


struct ProgressBarView: View {
    @Binding var value: Float
    @Binding var color : Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(self.color.opacity(0.3))
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(self.color)
                    .animation(.linear)
            }.cornerRadius(45.0)
        }
    }
}
