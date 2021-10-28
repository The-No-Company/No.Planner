//
//  WidgetView.swift
//  Planner
//
//  Created by Michael Safir on 14.10.2021.
//

import SwiftUI


struct WidgetView: View {
    
    @State var nodes : [[Int]] = []
    @State var found_defaults : Bool = false
    @State var maxValue = 1
    
    @State var color : Color = Color.init(hex: "ffffff")
    
    func getColor(integer: Int) -> Double{
        let color_ready = Double(Float(integer)/Float(self.maxValue))
        if (integer == self.maxValue){
            return 1.0
        }else{
            if ((color_ready + 0.1) > 1.0){
                return 0.9
            }else{
                return color_ready + 0.1
            }
        }
    }
    var body: some View {
        VStack{
            VStack{
                HStack(spacing: 4){
                    ForEach(self.nodes, id:\.self){ column in
                        VStack(spacing: 5){
                            ForEach(column, id:\.self){ item in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(item > 0 && self.found_defaults == true ? self.color.opacity(getColor(integer: item)) : Color.init(hex: "626567").opacity(0.2))
                                    .frame(width: 14, height: 14, alignment: .center)
                                    
                            }
                        }
                    }
                }
            }
            .background(Color.clear)
            .cornerRadius(8)
        }
        
        .onAppear{
            
            let defaults = UserDefaults(suiteName: "group.thenoco.co.noplanner")
            let savedArray = defaults!.object(forKey: "nodes") as? [[Int]] ?? []
            
            
            self.color = defaults!.widgetColor?.suColor ?? Color.init(hex: "ffffff")
            
            if (savedArray.count == 0){
                
                for _ in 0...16{
                    var node_column : [Int] = []
                    for k in 0...6{
                        node_column.append(k)
                    }
                    self.nodes.append(node_column)
                }
            }else{
                self.found_defaults = true
                self.nodes = savedArray
                self.maxValue = 1
                for i in savedArray{
                    for m in i{
                        if (m >= self.maxValue){
                            let ready = Float( Float(m) / 20.0 )
                            self.maxValue = m
                        }
                    }
                }
                
                
            }
        }.preferredColorScheme(.dark)
    }
}

extension Date {
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}
