//
//  logic.swift
//  Planner
//
//  Created by Michael Safir on 14.10.2021.
//

import Foundation
import SwiftUI
import WidgetKit

var LogicAPI: Logic = Logic()

class Logic: ObservableObject, Identifiable {
    public var id: Int = 0
    @Published var date_string : String = ""
    @Published var time_string : String = ""
    @Published var date : Date = Date()
    
    @Published var planner : Planner = Planner()
    
    @Published var types: [String: String] = ["none": "", "red": "Important", "blue": "Home", "green": "Rest", "orange": "Work", "purple": "Education", "": ""]
    
    var timer : Timer?
    
    func initTimer(){
        if timer == nil {
          let timer = Timer(timeInterval: 1.0,
                            target: self,
                            selector: #selector(getDate),
                            userInfo: nil,
                            repeats: true)
          RunLoop.current.add(timer, forMode: .common)
          
          self.timer = timer
        }
    }
    
    public func getDateToString(format: String = "dd.MM.yyyy", date: Date) -> String{
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        let result = formatter.string(from: date)
        
//        if (self.date_string == result){
//            return ""
//        }
        
        return result
        
    }
    
    @objc public func getDate(){
        let format : String = "dd.MM.yyyy"
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        let result = formatter.string(from: date)
        
        
        self.date = date
        self.date_string = result
        
        
        self.getTime()
        
    }
    
    
    public func getTime(format: String = "HH:mm"){
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        let result = formatter.string(from: date)
        
        DispatchQueue.main.async {
            self.time_string = result
        }
    }
    
    public func getColor(name: String) -> Color{
        var color = Color.init(hex: "2F2F2F")
        
        switch name {
        case "none":
            color = Color.init(hex: "2F2F2F")
        case "red":
            color = Color.init(hex: "E74C3C")
        case "green":
            color = Color.init(hex: "2ECC71")
        case "blue":
            color = Color.init(hex: "3498DB")
        case "orange":
            color = Color.init(hex: "F39C12")
        case "purple":
            color = Color.init(hex: "9B59B6")
        default:
            color = Color.init(hex: "2F2F2F")
        }
        
        return color
        
    }
    
    public func getIcon(name: String) -> String{
        return self.types[name] ?? ""
        
    }
    public func getIconsDegaults(){
        let defaults = UserDefaults(suiteName: "group.thenoco.co.noplanner")
        let savedArray = defaults!.object(forKey: "types") as? [String : String] ?? self.types
        
        self.types = savedArray
    }
    
}

class Planner: ObservableObject, Identifiable {
    public var id: Int = 0
    @Published var tasks : [Tasks] = []
    @Published var grouped: [Date : [Planner.Tasks]] = [:]
    
    public func generateWidget(){
        
    }
    
    public func getTasks(){
        RealmAPI.getTasks()
        self.groupTasks()
    }
    
    public func removeTask(id: Int){
        RealmAPI.deleteTask(id: id)
        self.getTasks()
        
    }
    
    public func groupTasks(){
        self.grouped = self.tasks.groupedBy(dateComponents: [.year, .month, .day])
        
        var nodes : [[Int]] = []
        for i in 0...16{
            var node_column : [Int] = []
            for k in 0...6{
                let date_past = Calendar.current.date(byAdding: .day, value: (-1*(7-k)-(i*7))+1, to: Date().noon)!
                
                let formatter = DateFormatter()
                formatter.locale =  Locale(identifier: "ru_RU")
                formatter.dateFormat = "dd.MM.yyyy"
                let result = formatter.string(from: date_past)
                
                var found : Int = 0
                for key in self.grouped.keys {
                    let result_group = formatter.string(from: key)
                    if (result_group == result){
                        found = self.grouped[key]!.count
                    }
                }
                
                if (found != 0){
                    
                    node_column.append(found)
                }else{
                    
                    node_column.append(0)
                }
                
            }
            nodes.append(node_column)
        }
        
        let nodes_reverse = nodes.reduce([],{ [$1] + $0 })
        
        
        let defaults = UserDefaults(suiteName: "group.thenoco.co.noplanner")
        defaults!.set(nodes_reverse, forKey: "nodes")

        WidgetCenter.shared.reloadAllTimelines()
        
        
    }
    
    public func addtask(text: String, date: Date, tags: [String]){
        let formatter = DateFormatter()
        formatter.locale =  Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let result = formatter.string(from: date)
        formatter.locale =  Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy.HH.mm.ss"
        let result_str_id = formatter.string(from: date)
        let result_id : Int = Int(result_str_id.replacingOccurrences(of: ".", with: "", options: .literal, range: nil))!
        
        
        RealmAPI.addTasks(id: result_id, text: text, date: date, tags: tags)
        
        
        
    }
    
    public struct Tasks : Hashable, Identifiable, Dated {
        var id: Int = 0
        var text: String
        var date: Date
        var display_date: String
        var tags: [String]
    }
    
}


protocol Dated {
    var date: Date { get }
}

extension Array where Element: Dated {
    func groupedBy(dateComponents: Set<Calendar.Component>) -> [Date: [Element]] {
        let initial: [Date: [Element]] = [:]
        let groupedByDateComponents = reduce(into: initial) { acc, cur in
            let components = Calendar.current.dateComponents(dateComponents, from: cur.date)
            let date = Calendar.current.date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }
        
        return groupedByDateComponents
    }
}
