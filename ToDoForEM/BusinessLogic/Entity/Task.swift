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

final class Task: Mappable {
    
    var dispostBag: DisposeBag = DisposeBag()
    var title: String = ""
    var todo: String = ""
    var completed: Bool = false
    var data: Double = 0
    var id: Int = 0
    var userID: Int = 0
    
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
    
    required init?(map: Map) {}

       func mapping(map: Map) {

           let stringToInt = TransformOf<Int, Any>(
               fromJSON: { value in
                   if let v = value as? Int { return v }
                   return nil
               },
               toJSON: { $0 }
           )

           todo      <- map["todo"]
           completed <- map["completed"]
           id        <- (map["id"], stringToInt)
           userID    <- (map["userId"], stringToInt)

           title = todo
           data = Date().timeIntervalSince1970
       }
    
}

extension Task: Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
}
