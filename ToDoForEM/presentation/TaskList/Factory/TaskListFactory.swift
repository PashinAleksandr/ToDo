//
//  TaskListFactory.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import Foundation
import Swinject

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

            let interactor = TaskListInteractor()
            interactor.output = presenter
            
            presenter.interactor = interactor
            viewController.output = presenter

            return viewController
        }.inObjectScope(.transient)
    }
}
