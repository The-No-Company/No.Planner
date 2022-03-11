//
//  IntentHandler.swift
//  SiriAddTasks
//
//  Created by Michael Safir on 12.12.2021.
//

import Intents
import WidgetKit

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    func createTasks(fromTitles taskTitles: [String]) -> [INTask] {
        var tasks: [INTask] = []
        tasks = taskTitles.map { taskTitle -> INTask in
            let task = INTask(title: INSpeakableString(spokenPhrase: taskTitle),
                              status: .completed,
                              taskType: .notCompletable,
                              spatialEventTrigger: nil,
                              temporalEventTrigger: nil,
                              createdDateComponents: nil,
                              modifiedDateComponents: nil,
                              identifier: nil)
            return task
        }
        return tasks
    }
      
}

extension IntentHandler : INAddTasksIntentHandling {
    
    public func handle(intent: INAddTasksIntent,
                       completion: @escaping (INAddTasksIntentResponse) -> Swift.Void) {
        
        let taskList = intent.targetTaskList
        
        var tasks: [INTask] = []
        if let taskTitles = intent.taskTitles {
            let taskTitlesStrings = taskTitles.map {
                taskTitle -> String in
                print(taskTitle.spokenPhrase)
                return taskTitle.spokenPhrase
            }
            tasks = createTasks(fromTitles: taskTitlesStrings)
            print(taskTitlesStrings)
            if (taskTitlesStrings.count == 0){
                let response = INAddTasksIntentResponse(code: .failure, userActivity: nil)
                completion(response)
                return
            }
            
            DispatchQueue.main.async {
                if (taskList != nil){
                    if (taskList?.title.spokenPhrase.lowercased() == "orange"){
                        LogicAPI.planner.addtask(text: taskTitlesStrings[0], date: Date(), tags: ["orange"])
                        WidgetCenter.shared.reloadAllTimelines()
                        let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
                        response.modifiedTaskList = intent.targetTaskList
                        response.addedTasks = tasks
                        completion(response)
                        return
                    }
                    
                    if (taskList?.title.spokenPhrase.lowercased() == "purple"){
                        LogicAPI.planner.addtask(text: taskTitlesStrings[0], date: Date(), tags: ["purple"])
                        WidgetCenter.shared.reloadAllTimelines()
                        let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
                        response.modifiedTaskList = intent.targetTaskList
                        response.addedTasks = tasks
                        completion(response)
                        return
                    }
                    
                    if (taskList?.title.spokenPhrase.lowercased() == "blue"){
                        LogicAPI.planner.addtask(text: taskTitlesStrings[0], date: Date(), tags: ["blue"])
                        WidgetCenter.shared.reloadAllTimelines()
                        let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
                        response.modifiedTaskList = intent.targetTaskList
                        response.addedTasks = tasks
                        completion(response)
                        return
                    }
                    
                    if (taskList?.title.spokenPhrase.lowercased() == "red"){
                        LogicAPI.planner.addtask(text: taskTitlesStrings[0], date: Date(), tags: ["red"])
                        let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
                        response.modifiedTaskList = intent.targetTaskList
                        response.addedTasks = tasks
                        completion(response)
                        return
                    }
                    
                    if (taskList?.title.spokenPhrase.lowercased() == "green"){
                        LogicAPI.planner.addtask(text: taskTitlesStrings[0], date: Date(), tags: ["green"])
                        let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
                        response.modifiedTaskList = intent.targetTaskList
                        response.addedTasks = tasks
                        completion(response)
                        return
                    }
                    
                    
                    if (taskList?.title.spokenPhrase.lowercased() == "оранджевый"){
                        LogicAPI.planner.addtask(text: taskTitlesStrings[0], date: Date(), tags: ["orange"])
                        let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
                        response.modifiedTaskList = intent.targetTaskList
                        response.addedTasks = tasks
                        completion(response)
                        return
                    }
                    
                    if (taskList?.title.spokenPhrase.lowercased() == "фиолетовый"){
                        LogicAPI.planner.addtask(text: taskTitlesStrings[0], date: Date(), tags: ["purple"])
                        let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
                        response.modifiedTaskList = intent.targetTaskList
                        response.addedTasks = tasks
                        completion(response)
                        return
                    }
                    
                    if (taskList?.title.spokenPhrase.lowercased() == "синий"){
                        LogicAPI.planner.addtask(text: taskTitlesStrings[0], date: Date(), tags: ["blue"])
                        let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
                        response.modifiedTaskList = intent.targetTaskList
                        response.addedTasks = tasks
                        completion(response)
                        return
                    }
                    
                    if (taskList?.title.spokenPhrase.lowercased() == "красный"){
                        LogicAPI.planner.addtask(text: taskTitlesStrings[0], date: Date(), tags: ["red"])
                        let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
                        response.modifiedTaskList = intent.targetTaskList
                        response.addedTasks = tasks
                        completion(response)
                        return
                    }
                    
                    if (taskList?.title.spokenPhrase.lowercased() == "зеленый"){
                        LogicAPI.planner.addtask(text: taskTitlesStrings[0], date: Date(), tags: ["green"])
                        let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
                        response.modifiedTaskList = intent.targetTaskList
                        response.addedTasks = tasks
                        completion(response)
                        return
                    }
                    
                    
                    LogicAPI.planner.addtask(text: taskTitlesStrings[0], date: Date(), tags: ["none"])
                    WidgetCenter.shared.reloadAllTimelines()
                    let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
                    response.modifiedTaskList = intent.targetTaskList
                    response.addedTasks = tasks
                    completion(response)
                    
                }else{
                    LogicAPI.planner.addtask(text: taskTitlesStrings[0], date: Date(), tags: ["none"])
                    WidgetCenter.shared.reloadAllTimelines()
                    let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
                    response.modifiedTaskList = intent.targetTaskList
                    response.addedTasks = tasks
                    completion(response)
                }
            }

        }
        
        
    }
    
}

