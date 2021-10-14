//
//  SettingsView.swift
//  Planner
//
//  Created by Michael Safir on 14.10.2021.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var logic: Logic = LogicAPI
    
    @State var none : String = ""
    @State var green : String = ""
    @State var blue : String = ""
    @State var orange : String = ""
    @State var red : String = ""
    
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 10){
                    //                    Block with information
                    VStack(spacing: 10){
                        HStack{
                            Text("Settings. 🥳")
                                .font(Font.custom("Spectral-Medium", size: 26))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        HStack{
                            Text("Customize the app to fit your needs. Add the tags you use in your daily life, specify the colors you like and customize the widget to your liking!")
                                .font(.custom("SourceCodePro-Regular", size: 14))
                                .foregroundColor(Color.secondary.opacity(0.7))
                            
                            Spacer()
                        } .padding(.horizontal, 20)
                        
                    }.padding(.top)
                    //                    Block with information END
                    
                    VStack(spacing: 10){
                        HStack{
                            Text("Tags")
                                .font(Font.custom("Spectral-Medium", size: 20))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.secondary.opacity(0.2))
                            .padding(.horizontal, 20)
                            .frame(height: 2)
                        
                    }.padding(.bottom, 10)
                    
                    VStack(spacing: 10){
                        HStack(spacing: 5){
                            
                            Button(action: {
                                
                            }, label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.init(hex: "2ECC71"))
                                }
                                .frame(width: 30, height: 30)
                            }).buttonStyle(ScaleButtonStyle())
                            
                            
                            Spacer()
                            
                            SearchBarView(text: self.$green, title: self.logic.getIcon(name: "green"), image: "tag", type: .webSearch)
                                
                        }
                        
                        HStack(spacing: 5){
                            
                            Button(action: {
                                
                            }, label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.init(hex: "3498DB"))
                                }
                                .frame(width: 30, height: 30)
                            }).buttonStyle(ScaleButtonStyle())
                            
                            
                            Spacer()
                            
                            SearchBarView(text: self.$blue, title: self.logic.getIcon(name: "blue"), image: "tag", type: .webSearch)
                                
                        }
                        
                        HStack(spacing: 5){
                            
                            Button(action: {
                                
                            }, label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.init(hex: "E74C3C"))
                                }
                                .frame(width: 30, height: 30)
                            }).buttonStyle(ScaleButtonStyle())
                            
                            
                            Spacer()
                            
                            SearchBarView(text: self.$red, title: self.logic.getIcon(name: "red"), image: "tag", type: .webSearch)
                                
                        }
                        
                        HStack(spacing: 5){
                            
                            Button(action: {
                                
                            }, label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.init(hex: "F39C12"))
                                }
                                .frame(width: 30, height: 30)
                            }).buttonStyle(ScaleButtonStyle())
                            
                            
                            Spacer()
                            
                            SearchBarView(text: self.$orange, title: self.logic.getIcon(name: "orange"), image: "tag", type: .webSearch)
                                
                        }
                    }.padding(.horizontal, 20)
                    
                    Spacer()
                    
                    
                }
            }
        }
    }
}

