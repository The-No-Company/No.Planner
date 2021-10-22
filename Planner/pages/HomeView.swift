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
    
   var topEdge: CGFloat
    
    @State var header : String = ""
    
    @SwiftUI.Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    
    init(topEdge: CGFloat){
        
        self.topEdge = topEdge
        
//        UIScrollView.appearance().bounces = false
        
        let apparence = UITabBarAppearance()
        apparence.configureWithOpaqueBackground()
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = apparence
        }
    }
    
  
    
    var body: some View {
        
            VStack(spacing: 0){
                HStack{
                    VStack(alignment: .leading){
                        Text("No.Planner")
                            .font(Font.custom("Spectral-Medium", size: 26))
                        if (self.logic.planner.grouped.keys.count > 0){
                            if (self.logic.minimum.date != self.logic.getDateToString(date: self.logic.planner.grouped.keys.sorted(by: {$0.timeIntervalSinceNow > $1.timeIntervalSinceNow})[0])){
                                Text(self.logic.minimum.date)
                                    .font(Font.custom("Spectral-Medium", size: 18))
                                    .foregroundColor(Color.white.opacity(0.7))
                            }else{
                                Text("Today")
                                    .font(Font.custom("Spectral-Medium", size: 18))
                                    .foregroundColor(Color.white.opacity(0.7))
                            }
                        }
                    }
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
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                    
                }
                
                
            }
            .padding(.top, self.topEdge)
            .sheet(isPresented: self.$showing_add) {
                SettingsView(close: self.$showing_add)
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

var minimum : minimumStructure = minimumStructure(date: "", index: 0)

struct minimumStructure : Identifiable, Hashable{
    var id = 0
    var date : String
    var index : CGFloat
}

struct TaskBox: View {

    @ObservedObject var logic: Logic = LogicAPI
    @State var key : Date

    
    var body: some View {
        ZStack(alignment: .top){
            
            VStack(spacing: 10){
                
                HStack{
                    GeometryReader { proxy -> Text in
                        let y = proxy.frame(in: .global).maxY
                        if (y < 100 && y > 0){
                            DispatchQueue.main.async {
                                self.logic.minimum.index = y
                                if (self.logic.getDateToString(date: key) == "Today"){
                                    self.logic.minimum.date = "~"
                                }else{
                                    self.logic.minimum.date = self.logic.getDateToString(date: key)
                                }
                            }
                        }
                        return Text(self.logic.getDateToString(date: key))
                            .font(Font.custom("Spectral-Medium", size: 26))
                    }
                    Spacer()
                    
                }
                .frame(height: self.logic.getDateToString(date: key).count > 0 ? 40 : 0)
                .background(Color.black)
        
                VStack(spacing: 10){
                    if (self.logic.planner.grouped[key] != nil){
                        ForEach(self.logic.planner.grouped[key]!.sorted(by: {$0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow}), id: \.self){ task in
                            TaskView(id: task.id, text: task.text, time: task.display_date, date: task.date, tags_array: task.tags)
                        }
                    }
                }
            }
        }
    }
}
