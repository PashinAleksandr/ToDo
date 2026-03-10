//
//  Errors.swift
//  ToDoForEM
//
//  Created by Aleksandr Pashin on 10.03.2026.
//

import Foundation

enum TaskError: LocalizedError {
    case nowData
    
    
    var errorDescription: String? {
        switch self {
        case.nowData:
            return "Не пришли данные с сервера"
        }
    }
}
