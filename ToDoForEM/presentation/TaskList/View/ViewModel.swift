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
        
        private let task:Task
        
        let title = BehaviorRelay<String>(value: "")
        let completed = BehaviorRelay<Bool>(value: false)
        let dataLabel = BehaviorRelay<String>(value: "")
        let todoLabel = BehaviorRelay<String>(value: "")
        
        init(task:Task) {
            self.task = task
            title.accept(task.title)
            completed.accept(task.completed)
            todoLabel.accept(task.todo)
            
            let date = Date(timeIntervalSince1970: task.data)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            dataLabel.accept(formatter.string(from: date))
        }
    }
}
