//
//  WelcomeView.swift
//  Planner
//
//  Created by Michael Safir on 20.10.2021.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var close : Bool
    
    var body: some View {
        VStack(alignment: .leading,spacing: 40){
            
            Spacer()
            
            HStack(spacing: 20){
                Image(systemName: "calendar")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .font(.system(size: 28))
                    
                
                Text("Add the tasks you've done each day and fill in the widget. Analyze your productivity.")
                    .font(.custom("SourceCodePro-Regular", size: 16))
                    .foregroundColor(Color.white.opacity(0.8))
            }
            
            HStack(spacing: 20){
                Image(systemName: "circle.hexagongrid")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .font(.system(size: 28))
                    
                
                Text("Specify different colors for the task categories and call them whatever you like.")
                    .font(.custom("SourceCodePro-Regular", size: 16))
                    .foregroundColor(Color.white.opacity(0.8))
            }
            
            HStack(spacing: 20){
                Image(systemName: "lock")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .font(.system(size: 28))
                    
                
                Text("Full confidentiality. We don't collect any data, we don't send notifications - your personal files are fully protected.")
                    .font(.custom("SourceCodePro-Regular", size: 16))
                    .foregroundColor(Color.white.opacity(0.8))
            }
            
            HStack(spacing: 20){
                Image(systemName: "creditcard")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .font(.system(size: 28))
                    
                
                Text("The app is completely free - we don't ask for subscriptions, use it comfortably.")
                    .font(.custom("SourceCodePro-Regular", size: 16))
                    .foregroundColor(Color.white.opacity(0.8))
            }
            
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    self.close.toggle()
                }, label: {
                    Text("go on")
                        .padding(.horizontal, 35)
                        .padding(.vertical, 5)
                        .background(Color.white)
                        .cornerRadius(8.0)
                        .foregroundColor(Color.black)
                        .font(Font.custom("Spectral-Medium", size: 16))
                }).buttonStyle(ScaleButtonStyle())
                    .padding(.bottom)
                Spacer()
            }
            
        }.padding()
    }
}
