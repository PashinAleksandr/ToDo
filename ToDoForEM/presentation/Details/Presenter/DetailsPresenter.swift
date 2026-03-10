//
//  DetailsPresenter.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import Foundation

class DetailsPresenter: NSObject, DetailsModuleInput, DetailsViewOutput {
    
    weak var view: DetailsViewInput!
    var interactor: DetailsInteractorInput!
    var router: DetailsRouterInput!
    var task: Task?
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func openTaskListVC() {
        router.openTaskListVC()
    }
    
    func configure(with task: Task) {
        self.task = task
    }
    
    func setupInitialState() {
        
    }
}

extension DetailsPresenter: DetailsInteractorOutput {
}
