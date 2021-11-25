//
//  HomeView.swift
//  Planner
//
//  Created by Michael Safir on 13.10.2021.
//

import SwiftUI
import Introspect

struct HomeView: View {
    @State private var showing_add = false
    @ObservedObject var logic: Logic = LogicAPI
    @State var search : Bool = false
    @State var respond : Bool = false
    @State var search_text : String = ""
    var topEdge: CGFloat
    
    @State var scale: CGFloat = 0.8
    @State var header : String = ""
    @ObservedObject var analytics: Analytics = AnalyticsAPI

    @SwiftUI.Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    
    init(topEdge: CGFloat){
        
        self.topEdge = topEdge
        
        //        UIScrollView.appearance().bounces = false
        
        let apparence = UITabBarAppearance()
        apparence.configureWithOpaqueBackground()
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = apparence
        }
        
        if #available(iOS 14.0, *) {
            // iOS 14 doesn't have extra separators below the list by default.
        } else {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
        }
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().showsVerticalScrollIndicator = false
        
    }
    
    
    
    var body: some View {
        
        VStack(spacing: 0){
            HStack{
                VStack(alignment: .leading){
                    Text("No.Planner")
                        .font(Font.custom("Spectral-Medium", size: 26))
                    if (self.logic.planner.grouped.keys.count > 0){
//                        if (self.logic.minimum.date != self.logic.getDateToString(date: self.logic.planner.grouped.keys.sorted(by: {$0.timeIntervalSinceNow > $1.timeIntervalSinceNow})[0])){
//                            Text(self.logic.minimum.date)
//                                .font(Font.custom("Spectral-Medium", size: 18))
//                                .foregroundColor(Color.white.opacity(0.7))
//                        }else{
//                            Text("Today")
//                                .font(Font.custom("Spectral-Medium", size: 18))
//                                .foregroundColor(Color.white.opacity(0.7))
//                        }
                        
                        Text("Add what's done")
                            .font(Font.custom("Spectral-Medium", size: 18))
                            .foregroundColor(Color.white.opacity(0.7))
                    }
                }
                Spacer()
                
                Button(action: {
                    if (UserDefaults.standard.bool(forKey: "haptic")){
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }
                    self.analytics.send(action: "search")
                    
                    
                    withAnimation{
                        self.search = true
                    }
                    
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                })
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.trailing, 10)
                
                Button(action: {
                    if (UserDefaults.standard.bool(forKey: "haptic")){
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }
                    
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
            
            if (self.search == true){
                HStack(spacing: 10){
                    SearchBarView(text: self.$search_text)
                        .introspectTextField { field in
                            if (self.search == true && self.respond == false){
                                self.respond = true
                                field.becomeFirstResponder()
                            }
                        }
                    if (self.search_text.count > 0 || self.search_text.count == 0){
                        Button(action: {
                            withAnimation(Animation.easeInOut(duration: 0.2)) {
                                self.search_text = ""
                                self.search = false
                                self.respond = false
                            }
                        }, label: {
                            Image(systemName: "xmark.square")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                        })
                            .scaleEffect(scale)
                            .onAppear {
                                let baseAnimation = Animation.easeInOut(duration: 0.3)
                                
                                withAnimation(baseAnimation) {
                                    scale = 1.0
                                }
                            }
                            .onDisappear{
                                let baseAnimation = Animation.easeInOut(duration: 0.3)
                                
                                withAnimation(baseAnimation) {
                                    scale = 0.8
                                }
                            }
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal, 10)
            }
            
            
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
                List(){
                    
                    ForEach(self.logic.planner.grouped.keys.sorted(by: {$0.timeIntervalSinceNow > $1.timeIntervalSinceNow}), id: \.self) { key in
                        if (self.logic.planner.grouped[key]!.filter{ $0.text.lowercased().contains(self.search_text.lowercased()) || self.search_text.isEmpty}.count > 0 ){
                            TaskBox(key: key, search_text: self.$search_text)
                                .listRowInsets(EdgeInsets())
                        }
                    }
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.horizontal, 10)
                .listStyle(.plain)
                .background(Color.black)
                
                
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
    @Binding var search_text : String
    @State var taskSelected : Planner.Tasks = Planner.Tasks(id: 0, text: "", date: Date(), display_date: "", tags: [])
    
    var body: some View {
        ZStack(alignment: .top){
            
            VStack(spacing: 5){
                
                
                HStack{
                    GeometryReader { proxy -> Text in
//                        let y = proxy.frame(in: .global).maxY
//                        if (y < 100 && y > 0){
//                            DispatchQueue.main.async {
//                                self.logic.minimum.index = y
//                                if (self.logic.getDateToString(date: key) == "Today"){
//                                    self.logic.minimum.date = "~"
//                                }else{
//                                    self.logic.minimum.date = self.logic.getDateToString(date: key)
//                                }
//                            }
//                        }
                        return Text(self.logic.getDateToString(date: key))
                            .font(Font.custom("Spectral-Medium", size: 26))
                    }
                    Spacer()
                    
                }
                .frame(height: self.logic.getDateToString(date: key).count > 0 ? 40 : 0)
                .background(Color.black)
                .padding(.top, 10)
                
                
                VStack(spacing: 15){
                    if (self.logic.planner.grouped[key] != nil){
                        ForEach(self.logic.planner.grouped[key]!.filter{ $0.text.lowercased().contains(self.search_text.lowercased()) || self.search_text.isEmpty}.sorted(by: {$0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow}), id: \.self){ task in
                            TaskView(id: task.id, text: task.text, time: task.display_date, date: task.date, tags_array: task.tags)
                        }
                    }
                }
            }
        }
    }
}


