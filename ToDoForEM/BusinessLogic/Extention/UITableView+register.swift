//
//  UITableView+register.swift
//  ToDoForEM
//
//  Created by Aleksandr Pashin on 09.03.2026.
//

import UIKit

extension UITableView {
    func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass.self, forCellReuseIdentifier: cellClass.identifier)
    }
}
