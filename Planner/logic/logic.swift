//
//  logic.swift
//  Planner
//
//  Created by Michael Safir on 14.10.2021.
//

import Foundation
import SwiftUI

var LogicAPI: Logic = Logic()

class Logic: ObservableObject, Identifiable {
    public var id: Int = 0
    @Published var date_string : String = ""
    @Published var time_string : String = ""
    @Published var date : Date = Date()
    
    @Published var planner : Planner = Planner()
    
    @Published var types: [String: String] = ["none": "", "red": "Important", "blue": "Home", "green": "Rest", "orange": "Work", "": ""]
    
    
    public func getDateToString(format: String = "dd.MM.yyyy", date: Date) -> String{
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        let result = formatter.string(from: date)
        
        if (self.date_string == result){
            return ""
        }
        
        return result
        
    }
    
    public func getDate(format: String = "dd.MM.yyyy"){
        DispatchQueue.global(qos: .userInitiated).async {
            let date = Date()
            let formatter = DateFormatter()
            
            formatter.dateFormat = format
            let result = formatter.string(from: date)
            
            DispatchQueue.main.async {
                self.date = date
                self.date_string = result
            }
            
            self.getTime()
        }
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
        default:
            color = Color.init(hex: "2F2F2F")
        }
        
        return color
        
    }
    
    public func getIcon(name: String) -> String{
        return self.types[name] ?? ""
        
    }
    
}

class Planner: ObservableObject, Identifiable {
    public var id: Int = 0
    @Published var tasks : [Tasks] = []
    @Published var grouped: [Date : [Planner.Tasks]] = [:]
    
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
