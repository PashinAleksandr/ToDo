//
//  Detailsinteractor.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import Foundation

class DetailsInteractor: DetailsInteractorInput {
    
    weak var output: DetailsInteractorOutput!
    var saveService: SaveServiceProtocol!
    
    func add(task: Task) {
        
        saveService.add(task) { [weak self] result in
            switch result {
            case .success:
                self?.output.taskSaved()
            case .failure(let error):
                self?.output.showError(error: error)
            }
        }
    }
}
