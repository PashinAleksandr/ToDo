//
//  Task.swift
//  ToDoForEM
//
//  Created by Aleksandr Pashin on 08.03.2026.
//

import Foundation
import ObjectMapper
import RxSwift
import RxRelay

final class Task {
    var dispostBag: DisposeBag = DisposeBag()
    var title: String
    var todo: String
    var completed: Bool
    var data: Double
    var id: Int
    var userID: Int
    
//    required init?(map: Map) {}
    
    init(title: String ,
         todo: String ,
         completed: Bool,
         data: Double,
         id: Int,
         userID: Int
    ) {
        self.todo = todo
        self.title = title
        self.completed = completed
        self.data = data
        self.id = id
        self.userID = userID
    }
    
    
    
    func mapping(map: ObjectMapper.Map) {
        
    }
    
}

extension Task: Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
}
