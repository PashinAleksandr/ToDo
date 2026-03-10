//
//  TaskListinteractor.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import Foundation

class TaskListInteractor: TaskListInteractorInput {

    weak var output: TaskListInteractorOutput!
    var taskService: TaskServiceProtocol!
    
    func loadTask() { 
        taskService.fetchTasks { [weak self] tasks, error in
            guard let self = self else { return }
            if let tasks = tasks {
                self.output.didUpdateTasks(tasks)
            }
            
            if let error = error {
                output.showError(error: error)
            }
        }
    }
}
