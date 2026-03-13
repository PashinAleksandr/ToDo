//
//  TaskListRouter.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import Foundation
import UIKit

class TaskListRouter: TaskListRouterInput {
    
    weak var transitionHandler: TransitionHandlerProtocol?
    
    func openDetails(for task: Task) {
        let factory = DetailsFactory(task: task)
        transitionHandler?.presentModule(usingFactory: factory)
    }
}
