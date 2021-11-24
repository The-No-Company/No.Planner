//
//  add_deal.swift
//  No.Chat
//
//  Created by out-safir-md on 05.10.2021.
//

import Foundation
import SwiftUI
import Introspect

struct AddView: View {
    
    @State var tag : String = "none"
    @State var id : Int = 0
    @State var text : String = ""
    @State var date : Date = Date()
    @State var openView : Bool = false
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var logic: Logic = LogicAPI
    @ObservedObject var analytics: Analytics = AnalyticsAPI

  
    
    var body: some View {
        
        VStack(spacing: 0){
            
            RoundedRectangle(cornerRadius: 8)
                .fill(self.logic.getColor(name: self.tag))
                .frame(height: 5)
                .padding(.horizontal, -15)
            
            
            HStack{
                Text(self.id != 0 ? "Edit / Remove " : "Add")
                    .font(Font.custom("Spectral-Medium", size: 26))
                Spacer()
                
                
                if (self.id != 0){
                    Button(action: {
                        DispatchQueue.main.async {
                            self.logic.planner.removeTask(id: self.id)
                        }
                        self.analytics.send(action: "remove_task")
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.red)
                            .opacity(0.5)
                    }).buttonStyle(ScaleButtonStyle())
                }
                
                Button(action: {
                    if (UserDefaults.standard.bool(forKey: "haptic")){
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }
                    
                    if (self.id != 0){
                        DispatchQueue.main.async {
                            self.logic.planner.updateTask(id: self.id, text: self.text, tags: [self.tag])
                        }
                        self.analytics.send(action: "update_task")
                        self.presentationMode.wrappedValue.dismiss()
                    }else{
                        self.logic.planner.addtask(text: self.text, date: Date(), tags: [self.tag])
                        self.analytics.send(action: "create_task")
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Image(systemName: "paperplane")
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(self.text.count == 0 ? 0.3 : 1.0)
                }).buttonStyle(ScaleButtonStyle())
                
                
           
                
                
            }
            .padding(.horizontal, 10)
            .padding(.top, 20)
            
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading, spacing: 10){
                    
                    if (self.id == 0){
                        Text("Hello! Add a finished assignment.")
                            .font(.custom("SourceCodePro-Regular", size: 14))
                            .foregroundColor(Color.secondary.opacity(0.7))
                    }else{
                        Text("You can correct the tags and text.")
                            .font(.custom("SourceCodePro-Regular", size: 14))
                            .foregroundColor(Color.secondary.opacity(0.7))
                    }
                    
                    ColorView(color: self.$tag)
                    
                    Text("Your message")
                        .foregroundColor(Color.white)
                        .font(.custom("Spectral-Medium", size: 18))
                    
                    TextEditor(text: self.$text)
                        .font(.custom("SourceCodePro-Regular", size: 18))
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(8)
                        .frame(height: 250)
                        .accentColor(.white)
                        .introspectTextView { field in
                            if (self.openView == false){
                                field.becomeFirstResponder()
                                self.openView = true
                            }
                        }
                    
                    
                }
                
                Spacer()
            }
            .padding(.horizontal, 10)
        }.onAppear{
            UITextView.appearance().backgroundColor = .clear
        }
    }
    
    
}

struct ColorView: View {
    
    @Binding var color : String
    @ObservedObject var logic: Logic = LogicAPI
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 10){
                
                Button(action: {
                    self.color = "none"
                }, label: {
                    ZStack {
                        Circle()
                            .fill(Color.init(hex: "2F2F2F"))
                        
                        if (self.color == "none"){
                            Circle()
                                .strokeBorder(Color.yellow, lineWidth: 2)
                        }
                    }
                    .frame(width: 30, height: 30)
                }).buttonStyle(ScaleButtonStyle())
                
                
                Button(action: {
                    self.color = "green"
                }, label: {
                    Text(self.logic.getIcon(name: "green"))
                        .font(.custom("SourceCodePro-Regular", size: 14))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.init(hex: "2ECC71"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(self.color == "green" ? Color.yellow : Color.clear, lineWidth: 2)
                        )
                    
                }).buttonStyle(ScaleButtonStyle())
                
                
                
                
                Button(action: {
                    self.color = "blue"
                }, label: {
                    Text(self.logic.getIcon(name: "blue"))
                        .font(.custom("SourceCodePro-Regular", size: 14))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.init(hex: "3498DB"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(self.color == "blue" ? Color.yellow : Color.clear, lineWidth: 2)
                        )
                    
                }).buttonStyle(ScaleButtonStyle())
                
                
                Button(action: {
                    self.color = "red"
                }, label: {
                    Text(self.logic.getIcon(name: "red"))
                        .font(.custom("SourceCodePro-Regular", size: 14))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.init(hex: "E74C3C"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(self.color == "red" ? Color.yellow : Color.clear, lineWidth: 2)
                        )
                    
                }).buttonStyle(ScaleButtonStyle())
                
                
                Button(action: {
                    self.color = "orange"
                }, label: {
                    Text(self.logic.getIcon(name: "orange"))
                        .font(.custom("SourceCodePro-Regular", size: 14))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.init(hex: "F39C12"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(self.color == "orange" ? Color.yellow : Color.clear, lineWidth: 2)
                        )
                    
                }).buttonStyle(ScaleButtonStyle())
                
                Button(action: {
                    self.color = "purple"
                }, label: {
                    Text(self.logic.getIcon(name: "purple"))
                        .font(.custom("SourceCodePro-Regular", size: 14))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.init(hex: "9B59B6"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(self.color == "purple" ? Color.yellow : Color.clear, lineWidth: 2)
                        )
                    
                }).buttonStyle(ScaleButtonStyle())
                
                
            }
        }
    }
}


