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
    
    @State var text : String = "Your text"
    @State var openView : Bool = false
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        VStack(spacing: 0){
            HStack{
                Text("Add")
                    .font(Font.custom("Spectral-Medium", size: 26))
                Spacer()
                
                Button(action: {
                  
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
                    
                    Text("Hello! Here you can add your own deal.")
                        .font(.custom("SourceCodePro-Regular", size: 14))
                        .foregroundColor(Color.secondary.opacity(0.7))
                    
                    Text("Your message")
                        .foregroundColor(Color.white)
                        .font(.custom("Spectral-Medium", size: 18))
                    
                    TextEditor(text: self.$text)
                            .font(.custom("SourceCodePro-Regular", size: 14))
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.secondary.opacity(0.2))
                            .cornerRadius(8)
                            .frame(height: 500)
                            .introspectTextView { field in
                                if (self.openView == false){
                                    field.becomeFirstResponder()
                                    field.selectAll(self)
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
