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
import CoreData

protocol TaskProviderProtocol {
    func fetchTasks(complitionHandler: @escaping ([Task]?, Error?) -> Void)
}

protocol SaveServiceProtocol: AnyObject {
    func add(_ task: Task)
    func remove(_ task: Task)
    func toggle(_ task: Task)
    func isContains(_ task: Task) -> Bool
    func loadTasksFromDB() -> [Task]
}


class SaveService: SaveServiceProtocol {
    
    private let context: NSManagedObjectContext
    private let disposeBag = DisposeBag()
    private let taskProvider: TaskServiceProtocol
    
    private var tasks: [Task] = []
    
    
    init(taskProvider: TaskServiceProtocol, context: NSManagedObjectContext) {
        self.taskProvider = taskProvider
        self.context = context
        bindTasks()
    }
    
    func update(entity: Entity, from task: Task) {
        entity.id = Int64(task.id)
        entity.title = task.title
        entity.todo = task.todo
        entity.date = task.data
        entity.complited = task.completed
    }
    
    private func bindTasks() {
        taskProvider.tasks
            .subscribe(onNext: { [weak self] tasks in
                self?.tasks = tasks
            })
            .disposed(by: disposeBag)
    }
    
    func add(_ task: Task) {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", task.id)
        
        if let entity = try? context.fetch(request).first {
            update(entity: entity, from: task)
        } else {
            let entity = Entity(context: context)
            update(entity: entity, from: task)
        }
        CoreDataStack.shared.saveContext()
        
        var currentTasks = taskProvider.tasks.value
        if let index = currentTasks.firstIndex(where: { $0.id == task.id }) {
            currentTasks[index] = task
        } else {
            currentTasks.append(task)
        }
        taskProvider.tasks.accept(currentTasks)
    }
    
    func remove(_ task: Task) {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", task.id)
        
        if let entity = try? context.fetch(request).first {
            context.delete(entity)
            CoreDataStack.shared.saveContext()
        }
        
        let currentTasks = taskProvider.tasks.value.filter { $0.id != task.id }
        taskProvider.tasks.accept(currentTasks)
    }
    
    func toggle(_ task: Task) {
        var currentTasks = taskProvider.tasks.value
        guard let index = currentTasks.firstIndex(where: { $0.id == task.id }) else { return }
        
        currentTasks[index].completed.toggle()
        
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", task.id)
        
        if let entity = try? context.fetch(request).first {
            entity.complited = currentTasks[index].completed
            CoreDataStack.shared.saveContext()
        }
        
        taskProvider.tasks.accept(currentTasks)
    }
    
    private func updated(entity: Entity, from task: Task) {
        entity.id = Int64(task.id)
        entity.title = task.title
        entity.todo = task.todo
        entity.date = task.data
        entity.userid = Int64(task.userID)
        entity.complited = task.completed
    }
    
    func map(entity: Entity) -> Task {
        return Task (title: entity.title ?? "", todo: entity.todo ?? "", completed: entity.complited, data: entity.date, id: Int(entity.id), userID: Int(entity.userid))
    }
    
    func isContains(_ task: Task) -> Bool {
        return tasks.contains { $0.id == task.id }
    }
    
    func loadTasksFromDB() -> [Task] {
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        
        guard let entities = try? context.fetch(request) else {
            return []
        }
        return entities.map { map(entity: $0) }
    }
}
