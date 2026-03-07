//
//  DetailsPresenter.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import Foundation

class DetailsPresenter: NSObject, DetailsModuleInput, DetailsViewOutput {
    func setupInitialState() {
        
    }
    

    weak var view: DetailsViewInput!
    var interactor: DetailsInteractorInput!
    var router: DetailsRouterInput!

    func viewIsReady() {
        view.setupInitialState()
    }
}

extension DetailsPresenter: DetailsInteractorOutput {
}
