//
//  db.swift
//  Planner
//
//  Created by Michael Safir on 14.10.2021.
//

import Foundation
import SwiftUI
import RealmSwift

var RealmAPI: RealmDB = RealmDB()

class RealmDB: ObservableObject, Identifiable {
    var id: Int = 0
    @ObservedObject var logic: Logic = LogicAPI
    
    let realm : Realm
    init() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        realm = try! Realm()
    }
    
    func deleteTask(id: Int) {
        let realm = try! Realm()
        let object = realm.objects(Task.self).filter("id = \(id)")
        try! realm.write {
            realm.delete(object)
        }
        self.getTasks()
    }
    
    func getTasks() {
        let realm = try! Realm()
        let objects = realm.objects(Task.self)
        
        if (objects.count > 0) {
            
            
            var tmp_tasks : [Planner.Tasks] = []
            
            
            
            self.logic.planner.objectWillChange.send()
            self.logic.planner.tasks.removeAll()
            
            for i in 0...objects.count - 1 {
                
                var tags : [String] = []
                for tag in objects[i].tags{
                    tags.append(tag)
                }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let result = formatter.string(from: objects[i].date)
                
                tmp_tasks.append(Planner.Tasks(id: objects[i].id,
                                               text: objects[i].text,
                                               date: objects[i].date,
                                               display_date: result,
                                               tags: tags))
                
            }
            
            self.logic.planner.tasks = tmp_tasks
            self.logic.planner.groupTasks()
            
            
            
            
        }else{
            self.logic.planner.objectWillChange.send()
            self.logic.planner.tasks.removeAll()
        }
        
    }
    
    func addTasks(id: Int, text: String, date: Date, tags: [String]){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let result = formatter.string(from: date)
        
        let task = Task()
        task.id = id
        task.text = text
        for tag in tags {
            task.tags.append(tag)
        }
        task.date = date
        task.display_date = result
        
        
        
        try! realm.write {
            realm.add(task)
        }
        
        self.getTasks()
        
    }
    
}


open class Task: Object {
    @objc dynamic var id = 0
    @objc dynamic var text : String = ""
    let tags = RealmSwift.List<String>()
    @objc dynamic var date: Date = Date()
    @objc dynamic var display_date : String = ""
    
    
}

