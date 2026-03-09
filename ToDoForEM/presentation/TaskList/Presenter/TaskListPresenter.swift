//
//  TaskListPresenter.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import Foundation

class TaskListPresenter: NSObject, TaskListModuleInput, TaskListViewOutput {

    weak var view: TaskListViewInput!
    var interactor: TaskListInteractorInput!
    var router: TaskListRouterInput!

    func viewIsReady() {
        view.setupInitialState()
    }
    
    func loadTask() {
        interactor.loadTask()
    }
    
    func didSelectTask(_ task: TODO) {
        router.openDetails(for: task)
    }
    
    
}

extension TaskListPresenter: TaskListInteractorOutput {
}
