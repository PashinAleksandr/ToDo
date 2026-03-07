//
//  TaskListViewController.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController, TaskListViewInput {

    var output: TaskListViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: TaskListViewInput
    func setupInitialState() {
    }
}
