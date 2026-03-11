//
//  DetailsFactory.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import Swinject
import Foundation

class DetailsFactory: PresentationModuleFactory {
    
    private let task: Task
    
    init(task: Task) {
        self.task = task
    }

    func instantiateViewController() -> DetailsViewController {
        let vc = MainModuleAssembler.resolver.resolve(DetailsViewController.self, argument: task)!
        return vc
    }
    
    func instantiateTransitionHandler() -> TransitionHandlerProtocol {
        return instantiateViewController()
    }
}

class DetailsModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DetailsViewController.self) { (resolver: Resolver, task: Task) in
            let vc = DetailsViewController()
            let router = DetailsRouter()
            router.transitionHandler = vc

            let presenter = DetailsPresenter()
            presenter.view = vc
            presenter.router = router

            vc.output = presenter

            let interactor = DetailsInteractor()
            presenter.interactor = interactor
            interactor.output = presenter
            presenter.configure(with: task)
            interactor.saveService = container.resolve(SaveServiceProtocol.self)

            return vc
        }.inObjectScope(.transient)
        
        //TODO: 
        container.register(SaveServiceProtocol.self) { resolver in
            let taskProvider = resolver.resolve(TaskServiceProtocol.self)!
            return SaveService(taskProvider: taskProvider)
        }.inObjectScope(.container)
    }
}
