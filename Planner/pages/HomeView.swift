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
    
    func CreateTopArea(position: CGFloat, date: Date) -> CGFloat{
        
        if (position > 0){
            if (self.logic.getDateToString(date: date) == ""){
                DispatchQueue.main.async {
                    self.header = self.logic.date_string
                }
            }else{
                let keys_ready = self.logic.planner.grouped.keys.sorted(by: {$0.timeIntervalSinceNow > $1.timeIntervalSinceNow})
                if (self.logic.getDateToString(date: date) == self.logic.getDateToString(date: keys_ready.first!)){
                 
                    DispatchQueue.main.async {
                        self.header = self.logic.date_string
                    }
                }
            }
           
            if (position < 60){
                DispatchQueue.main.async {
                    self.header = self.logic.getDateToString(date: date)
                }
                
                if (self.logic.getDateToString(date: date) == ""){
                    DispatchQueue.main.async {
                        self.header = self.logic.date_string
                    }
                }
            }
        }
        
    
        
        return 40
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0){
                HStack{
                    Text("\(self.header)")
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
                        
//                        if (self.logic.planner.grouped.keys[Date()] == nil){
//                            HStack{
//                                Spacer()
//                                
//                                Text("Add finished task")
//                                    .font(.custom("SourceCodePro-Regular", size: 16))
//                                    .foregroundColor(Color.secondary.opacity(0.7))
//                                
//                                Spacer()
//                            }
//                        }
                        
                        
                        ForEach(self.logic.planner.grouped.keys.sorted(by: {$0.timeIntervalSinceNow > $1.timeIntervalSinceNow}), id: \.self) { key in
                            
                            VStack(spacing: 5){
                                
                                HStack{
                                    GeometryReader { header_geo in
                                        Text(self.logic.getDateToString(date: key))
                                            .frame(height: self.CreateTopArea(position: header_geo.frame(in: .global).minY, date: key))
                                            .font(Font.custom("Spectral-Medium", size: 26))
                                        Spacer()
                                    }
                                }.frame(height: self.logic.getDateToString(date: key) != "" ? 40 : 1)
                                
                                VStack(spacing: 10){
                                    ForEach(self.logic.planner.grouped[key]!.sorted(by: {$0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow}), id: \.self){ task in
                                        TaskView(id: task.id, text: task.text, time: task.display_date, date: task.date, tags_array: task.tags)
                                    }
                                }
                            }
                            
                            
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
