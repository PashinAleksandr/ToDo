//
//  UITableViewCell+identifier.swift
//  ToDoForEM
//
//  Created by Aleksandr Pashin on 09.03.2026.
//

import UIKit

extension UITableViewCell {
    
    static var identifier: String {
        String(describing: Self.self)
    }
    
    var identifier: String {
        Self.identifier
    }
}

