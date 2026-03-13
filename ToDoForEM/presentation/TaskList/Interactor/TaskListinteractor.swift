//
//  TaskListinteractor.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class TaskListInteractor: TaskListInteractorInput {
    
    weak var output: TaskListInteractorOutput!
    private let taskService: TaskServiceProtocol
    private let saveService: SaveServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(taskService: TaskServiceProtocol,
         saveService: SaveServiceProtocol) {
        
        self.taskService = taskService
        self.saveService = saveService
        
    }
    
    func subscribeOnTasks() {
        taskService.tasks
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] tasks in
                self?.output.didUpdateTasks(tasks)
            })
            .disposed(by: disposeBag)
    }
    
    func delete(task: Task) {
        saveService.remove(task)
    }
    
    func loadTask() {
        taskService.fetchTasks { [weak self] tasks, error in
            guard let self = self else { return }
            
            if let tasks = tasks {
                var uniqueTasks = saveService.loadTasksFromDB()
                for newTask in tasks {
                    let isDuplicate = uniqueTasks.contains { existing in
                        existing.id == newTask.id &&
                        existing.title == newTask.title &&
                        existing.todo == newTask.todo
                    }
                    if !isDuplicate {
                        uniqueTasks.append(newTask)
                        
                        self.saveService.add(newTask)
                    }
                }
                self.output.didUpdateTasks(uniqueTasks)
            }
            if let error = error {
                self.output.showError(error: error)
            }
        }
    }
}
