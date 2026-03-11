//
//  SaveService.swift
//  ToDoForEM
//
//  Created by Aleksandr Pashin on 10.03.2026.
//

import RxSwift
import RxRelay
import RxCocoa
import Foundation

protocol TaskProviderProtocol {
    func fetchTasks(complitionHandler: @escaping ([Task]?, Error?) -> Void)
}

protocol SaveServiceProtocol: AnyObject {
    func add(_ task: Task)
    func remove(_ task: Task)
    func toggle(_ task: Task)
    func isContains(_ task: Task) -> Bool
    var tasks: BehaviorRelay<[Task]> { get }
}


class SaveService: SaveServiceProtocol {
    func remove(_ task: Task) {
        
    }
    
    func toggle(_ task: Task) {
        
    }
    
    func isContains(_ task: Task) -> Bool {
        return true
    }
    

    private let disposeBag = DisposeBag()
    private let taskProvider: TaskServiceProtocol

    var tasks = BehaviorRelay<[Task]>(value: [])

    init(taskProvider: TaskServiceProtocol) {
        self.taskProvider = taskProvider
        bindTasks()
    }

    private func bindTasks() {
        taskProvider.tasks
            .subscribe(onNext: { [weak self] tasks in
                self?.tasks.accept(tasks)
            })
            .disposed(by: disposeBag)
    }

    func add(_ task: Task) {
        var tmp = tasks.value
        tmp.append(task)
        tasks.accept(tmp)
        taskProvider.tasks.accept(tasks.value)
    }

//    func remove(_ task: Task) {
//        tasks.value.removeAll { $0.id == task.id }
//        taskProvider.tasks.accept(tasks)
//    }
//
//    func toggle(_ task: Task) {
//        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
//        tasks[index].completed.toggle()
//        taskProvider.tasks.accept(tasks)
//    }
//
//    func isContains(_ task: Task) -> Bool {
//        return tasks.contains { $0.id == task.id }
//    }
}
