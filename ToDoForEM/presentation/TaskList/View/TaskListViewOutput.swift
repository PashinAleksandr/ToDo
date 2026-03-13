//
//  TaskListViewOutput.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol TaskListViewOutput {
    
    /**
     @author APashin
     Notify presenter that view is ready
     */
    
    func viewIsReady()
    func didSelectTask(_ task: Task)
    func loadTask()
    var tasks: BehaviorRelay<[Task]> { get set }
    func deleteTask(_ task: Task)
    
    
}
