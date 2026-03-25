//
//  TaskService.swift
//  ToDoForEM
//
//  Created by Aleksandr Pashin on 10.03.2026.
//

import Foundation
import Alamofire
import RxSwift
import RxRelay
import ObjectMapper
import CoreData

protocol TaskServiceProtocol {
    var tasks: BehaviorRelay<[Task]> { get set }
    func fetchTasks(complitionHandler: @escaping ([Task]?, Error?) -> Void)
}

final class TaskService: TaskServiceProtocol {
    var tasks = BehaviorRelay<[Task]>(value: [])
    
    func fetchTasks(complitionHandler: @escaping ([Task]?, Error?) -> Void) {
        AF.request(Config.API.baseURL).responseJSON { response in
            switch response.result {
                
            case .success(let value):
                guard
                    let json = value as? [String: Any],
                    let listArray = json["todos"] as? [[String: Any]]
                else {
                    complitionHandler(nil, TaskError.nowData)
                    return
                }
                let newTasksRaw = Mapper<Task>().mapArray(JSONArray: listArray)
                self.tasks.accept(newTasksRaw)
                complitionHandler(newTasksRaw, nil)
                
            case .failure(let error):
                complitionHandler(nil, error)
            }
        }
    }
}
