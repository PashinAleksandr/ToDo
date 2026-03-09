//
//  VIewModel.swift
//  ToDoForEM
//
//  Created by Aleksandr Pashin on 08.03.2026.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import SnapKit

extension TaskListTableViewCell {
    class ViewModel {
        
        var dispostBag = DisposeBag()
        
        private let task:TODO
        
         let title = BehaviorRelay<String>(value: "")
         let completed = BehaviorRelay<Bool>(value: false)
         let dataLabel = BehaviorRelay<String>(value: "")
         let todoLabel = BehaviorRelay<String>(value: "")
        
        init(task:TODO) {
            self.task = task
            title.accept(task.title)
            completed.accept(task.completed)
            dataLabel.accept(task.data.description)
            todoLabel.accept(task.todo)
        }
    }
}
