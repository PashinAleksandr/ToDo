//
//  MainModuleAssembler.swift
//  ToDoForEM
//
//  Created by Aleksandr Pashin on 07.03.2026.
//

import Swinject

final class MainModuleAssembler {
    
    private static var assembler: Assembler!
    
    public static var resolver: Resolver {
        return MainModuleAssembler.assembler.resolver
    }
    
    private init() {}
    
    static func initialise() {
        MainModuleAssembler.assembler = MainModuleAssembler.assemble()
    }
    
    private static func assemble() -> Assembler {
        let allModules = initPresentationModules() + initServiceModules()
        return Assembler(allModules)
    }
    
}

extension MainModuleAssembler {
    
    private static func initPresentationModules() -> [Assembly] {
        return [TaskListModuleAssembly(), DetailsModuleAssembly()
        ]
    }
    
    private static func initServiceModules() -> [Assembly] {
        return [
        
        ]
    }
    
}
