//
//  SettingsView.swift
//  Planner
//
//  Created by Michael Safir on 14.10.2021.
//

import SwiftUI

struct SettingsView: View {
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
                        
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

