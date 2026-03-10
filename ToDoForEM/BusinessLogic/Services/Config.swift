//
//  Config.swift
//  ToDoForEM
//
//  Created by Aleksandr Pashin on 10.03.2026.
//

import Foundation

func isDebug() -> Bool {
    var isDebug: Bool!
#if DEBUG
    isDebug = true
#else
    isDebug = false
#endif
    return isDebug
}

class Config {
    class API {
        static let baseURL = "https://dummyjson.com/todos"
    }
}
