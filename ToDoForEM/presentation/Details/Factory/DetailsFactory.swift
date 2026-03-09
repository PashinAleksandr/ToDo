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
    
    private let task: TODO
    
    init(task: TODO) {
        self.task = task
    }

    func instantiateViewController() -> DetailsViewController {
        let viewController = MainModuleAssembler.resolver.resolve(DetailsViewController.self)!
        return viewController
    }
    
    func instantiateTransitionHandler() -> TransitionHandlerProtocol {
        return instantiateViewController()
    }
}

class DetailsModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DetailsViewController.self) { (resolver: Resolver) in
            let viewController = DetailsViewController()
            let router = DetailsRouter()
            router.transitionHandler = viewController

            let presenter = DetailsPresenter()
            presenter.view = viewController
            presenter.router = router

            viewController.output = presenter

            let interactor = DetailsInteractor()
            presenter.interactor = interactor
            interactor.output = presenter
            //Экран коина!!

            return viewController
        }.inObjectScope(.transient)
    }
}
