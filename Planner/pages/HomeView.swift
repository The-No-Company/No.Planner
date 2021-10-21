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
    
    
    @State var header : String = ""
    
    @SwiftUI.Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    
    init(){
        let apparence = UITabBarAppearance()
        apparence.configureWithOpaqueBackground()
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = apparence
        }
    }
    
  
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0){
                HStack{
                    Text("Good day!")
                        .font(Font.custom("Spectral-Medium", size: 26))
                    Spacer()
                    
                    Button(action: {
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        
                        print("open_settings")
                        self.showing_add.toggle()
                    }, label: {
                        Image(systemName: "gear")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                    })
                        .buttonStyle(ScaleButtonStyle())
                        .padding(.trailing, 10)
                    
                }
                .padding(.horizontal, 10)
                
                if (self.logic.planner.tasks.count == 0){
                    VStack(spacing: 0){
                        Spacer()
                        VStack(spacing: 10){
                            Text("No.Tasks")
                                .font(.custom("SourceCodePro-Regular", size: 16))
                                .foregroundColor(Color.secondary.opacity(0.7))
                            
                            Text("\(self.logic.time_string)")
                                .font(Font.custom("Spectral-Medium", size: 32))
                        }
                        
                        Spacer()
                    }
                }else{
                    ScrollView(.vertical, showsIndicators: false){
                        
                        ForEach(self.logic.planner.grouped.keys.sorted(by: {$0.timeIntervalSinceNow > $1.timeIntervalSinceNow}), id: \.self) { key in
                            
                            
                            TaskBox(key: key)
                           
                            
                            
                            
                        }
                        Spacer()
                    }
                    .padding(.top)
                    .padding(.horizontal, 10)
                    
                }
                
                
            }.sheet(isPresented: self.$showing_add) {
                SettingsView(close: self.$showing_add)
            }
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

struct TaskBox: View {
    
    @State var topOffset : CGFloat = 0
    @State var bottomOffset : CGFloat = 0
    @ObservedObject var logic: Logic = LogicAPI
    @State var key : Date
    
    func getOpacity() -> CGFloat{
        if (self.bottomOffset < 40){
            let progress = bottomOffset / 40
            return progress
        }
        return 1
    }
    
    var body: some View {
        VStack(spacing: 5){
            
            VStack(spacing: 10){
                
                HStack{
                    
                    Text(self.logic.getDateToString(date: key))
                        .frame(height: 40)
                        .font(Font.custom("Spectral-Medium", size: 26))
                        .opacity(self.getOpacity())
                    Spacer()
                    
                }
                .background(Color.black)
                .offset(y: self.topOffset >= 100 ? 0 : -topOffset + 100)
                .frame(height: 40)
                .zIndex(1)
              
               
                
                
                
                ForEach(self.logic.planner.grouped[key]!.sorted(by: {$0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow}), id: \.self){ task in
                    TaskView(id: task.id, text: task.text, time: task.display_date, date: task.date, tags_array: task.tags)
                }
            }
            .zIndex(0)
            .clipped()
            .background(
                GeometryReader{ proxy -> Color in
                    
                    let minY = proxy.frame(in: .global).minY
                    let maxY = proxy.frame(in: .global).maxY
                    
                    DispatchQueue.main.async{
                        self.topOffset = minY
                        self.bottomOffset = maxY - 100
                    }
                    
                    return Color.clear
                }
            )
//            end all tasks in this day
        }
    }
}
