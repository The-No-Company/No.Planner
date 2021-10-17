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
    
    @State var text : String = ""
    @State var openView : Bool = false
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var logic: Logic = LogicAPI
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        VStack(spacing: 0){
            
            RoundedRectangle(cornerRadius: 8)
                .fill(self.logic.getColor(name: self.tag))
                .frame(height: 5)
                .padding(.horizontal, -15)
            
            
            HStack{
                Text("Add")
                    .font(Font.custom("Spectral-Medium", size: 26))
                Spacer()
                
                Button(action: {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    
                    self.logic.planner.addtask(text: self.text, date: Date(), tags: [self.tag])
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "paperplane")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(self.text.count == 0 ? 0.3 : 1.0)
                }).buttonStyle(ScaleButtonStyle())
                
                
            }
            .padding(.horizontal, 10)
            .padding(.top, 20)
            
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading, spacing: 10){
                    
                    Text("Hello! Add a finished assignment.")
                        .font(.custom("SourceCodePro-Regular", size: 14))
                        .foregroundColor(Color.secondary.opacity(0.7))
                    
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
                        .frame(height: 500)
                        .disableAutocorrection(true)
                        .tag(2)
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


