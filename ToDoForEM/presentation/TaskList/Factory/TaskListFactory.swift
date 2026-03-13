//
//  TaskListFactory.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import Foundation
import Swinject
import CoreData

class TaskListFactory: PresentationModuleFactory {
    
    func instantiateViewController() -> TaskListViewController {
        let viewController = MainModuleAssembler.resolver.resolve(TaskListViewController.self)!
        return viewController
    }
    
    func instantiateTransitionHandler() -> TransitionHandlerProtocol {
        return instantiateViewController()
    }
}

class TaskListModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(TaskListViewController.self) { (resolver: Resolver) in
            let viewController = TaskListViewController()
            
            let router = TaskListRouter()
            router.transitionHandler = viewController
            
            let presenter = TaskListPresenter()
            presenter.view = viewController
            presenter.router = router
            
            viewController.output = presenter
            
            let interactor = TaskListInteractor(
                taskService: resolver.resolve(TaskServiceProtocol.self)!,
                saveService: resolver.resolve(SaveServiceProtocol.self)!
            )
            
            interactor.output = presenter
            
            presenter.interactor = interactor
            viewController.output = presenter
            
            return viewController
        }.inObjectScope(.transient)
        container.register(TaskServiceProtocol.self) { _ in
            TaskService()
        }.inObjectScope(.container)
        
        container.register(SaveServiceProtocol.self) { resolver in
            SaveService(
                taskProvider: resolver.resolve(TaskServiceProtocol.self)!, context:CoreDataStack.shared.context)
        }.inObjectScope(.container)
    }
}
