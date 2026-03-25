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
    func add(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void)
    func remove(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void)
    func loadTasksFromDB(completion: @escaping ([Task]) -> Void)
    func toggle(_ task: Task)
    func isContains(_ task: Task) -> Bool
}

class SaveService: SaveServiceProtocol {
    
    private let queue = DispatchQueue(label: "SaveServiceQueue", qos: .background)
    private let context: NSManagedObjectContext
    private let disposeBag = DisposeBag()
    private let taskProvider: TaskServiceProtocol
    
    private var tasks: [Task] = []
    
    init(taskProvider: TaskServiceProtocol, context: NSManagedObjectContext) {
        self.taskProvider = taskProvider
        self.context = context
        bindTasks()
    }
    
    private func bindTasks() {
        taskProvider.tasks
            .subscribe(onNext: { [weak self] tasks in
                self?.tasks = tasks
            })
            .disposed(by: disposeBag)
    }
    
    func add(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        
        queue.async { [weak self] in
            guard let self else { return }
            let context = self.context
            context.performAndWait {
                do {
                    let request: NSFetchRequest<Entity> = Entity.fetchRequest()
                    request.predicate = NSPredicate(format: "id == %d", task.id)
                    if let entity = try context.fetch(request).first {
                        self.updated(entity: entity, from: task)
                    } else {
                        let entity = Entity(context: context)
                        self.updated(entity: entity, from: task)
                    }
                    try context.save()
                    DispatchQueue.main.async {
                        var currentTasks = self.taskProvider.tasks.value
                        if let index = currentTasks.firstIndex(where: { $0.id == task.id }) {
                            currentTasks[index] = task
                        } else {
                            currentTasks.append(task)
                        }
                        self.taskProvider.tasks.accept(currentTasks)
                        completion(.success(()))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    
    func remove(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self else { return }
            let context = self.context
            context.performAndWait {
                do {
                    let request: NSFetchRequest<Entity> = Entity.fetchRequest()
                    request.predicate = NSPredicate(format: "id == %d", task.id)
                    if let entity = try context.fetch(request).first {
                        context.delete(entity)
                    }
                    try context.save()
                    DispatchQueue.main.async {
                        let currentTasks = self.taskProvider.tasks.value.filter { $0.id != task.id }
                        self.taskProvider.tasks.accept(currentTasks)
                        completion(.success(()))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func toggle(_ task: Task) {
        let currentTasks = taskProvider.tasks.value
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
    
    func loadTasksFromDB(completion: @escaping ([Task]) -> Void) {
        queue.async { [weak self] in
            guard let self else { return }
            let request: NSFetchRequest<Entity> = Entity.fetchRequest()
            let entities = (try? self.context.fetch(request)) ?? []
            let tasks = entities.map { self.map(entity: $0) }
            DispatchQueue.main.async {
                completion(tasks)
            }
        }
    }
}
