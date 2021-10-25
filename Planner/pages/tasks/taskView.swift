//
//  taskView.swift
//  Planner
//
//  Created by Michael Safir on 14.10.2021.
//

import Foundation
import SwiftUI

struct TaskView: View {
    @ObservedObject var logic: Logic = LogicAPI
    
    @State var id : Int = 0
    @State var text : String = ""
    @State var time : String = ""
    
    @State var date : Date = Date()
    @State var showing_add = false
    @State var tags_array : [String] = []
    
    
    
    var body: some View {
        
        
        Button(action: {
            self.showing_add.toggle()
        }, label: {
            VStack(alignment: .leading, spacing: 4){
                RoundedRectangle(cornerRadius: 8)
                    .fill(self.tags_array.count > 0 ? self.logic.getColor(name: self.tags_array[0]) : .clear)
                    .frame(height: self.tags_array.count > 0 ? 5 : 0)
                    .padding(.top, -10)
                    .padding(.horizontal, -15)
                
                Text(self.text)
                    .font(.custom("SourceCodePro-Regular", size: 16))
                
                HStack{
                    if (self.tags_array.count > 0){
                        if (self.tags_array[0] != "none" && self.tags_array[0] != ""){
                            Text(self.logic.getIcon(name: self.tags_array.count > 0 ? self.tags_array[0] : "none"))
                                .foregroundColor(Color.white.opacity(0.7))
                                .font(.custom("SourceCodePro-Regular", size: 14))
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing){
                        Text(self.time)
                            .foregroundColor(Color.secondary.opacity(0.7))
                            .font(.custom("SourceCodePro-Regular", size: 14))
                    }
                }
            }
            .padding(10)
            .background(Color.init(hex: "2F2F2F"))
            .cornerRadius(8)
            
        }).buttonStyle(ScaleButtonStyle())
        
            .sheet(isPresented: self.$showing_add) {
                AddView(tag: tags_array.count > 0 ? tags_array[0] : "none", id: self.id, text: self.text, date: self.date)
            }
            .onAppear{
                
                let exampleDate = self.date
                
                let formatter = RelativeDateTimeFormatter()
                formatter.unitsStyle = .abbreviated
                let relativeDate = formatter.localizedString(for: exampleDate, relativeTo: Date())
                
                let formatter2 = DateFormatter()
                formatter2.locale =  Locale(identifier: "ru_RU")
                formatter2.dateFormat = "dd.MM.yyyy"
                let result = formatter2.string(from: self.date)
                
                
            }
    }
}

