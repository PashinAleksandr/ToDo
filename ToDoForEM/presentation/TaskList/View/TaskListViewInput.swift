//
//  TaskListViewInput.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import Foundation

protocol TaskListViewInput: UIViewInput {

    /**
        @author APashin
        Setup initial state of the view
    */

    func setupInitialState()
    func showTasks(_ tasks: [Task])
}
