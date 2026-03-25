//
//  TaskListPresenter.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class TaskListPresenter: NSObject, TaskListModuleInput, TaskListViewOutput {
    
    weak var view: TaskListViewInput!
    var interactor: TaskListInteractorInput!
    var router: TaskListRouterInput!
    var tasks = BehaviorRelay<[Task]>(value: [])
    
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func loadTask() {
        interactor.loadTask()
    }
    
    func didSelectTask(_ task: Task) {
        router.openDetails(for: task)
    }
    
    
}

extension TaskListPresenter: TaskListInteractorOutput {
    func showError(error: Error) {
        view.show(error)
    }
    
    func didUpdateTasks(_ tasks: [Task]) {
        self.tasks.accept(tasks)
    }
    
}

extension TaskListPresenter {
    func deleteTask(_ task: Task) {
        let currentTasks = tasks.value
        tasks.accept(currentTasks)
        interactor.delete(task: task)
    }
}
