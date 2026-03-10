//
//  DetailsRouter.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import Foundation

class DetailsRouter: DetailsRouterInput {
	weak var transitionHandler: TransitionHandlerProtocol?
    
    func openTaskListVC() {
        transitionHandler?.closeModule(true)
    }
}
