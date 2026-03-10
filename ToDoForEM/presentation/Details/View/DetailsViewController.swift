//
//  DetailsViewController.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

class DetailsViewController: UIViewController, DetailsViewInput {
    
    var output: DetailsViewOutput!
    var task: Task? {output?.task}
    private let taskTitleTextField = UITextField()
    private let dataLabel = UILabel()
    private let todoTextView = UITextView()
    private let backButton = UIButton()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        setupInitialState()
    }
    
    
    // MARK: DetailsViewInput
    func setupInitialState() {
        setupUI()
        if let task = task {
            configure(with: task)
        }
    }
    
    func saveTask() {
        
    }
    
    func configure(with task: Task) {let formatter = DateFormatter()
        let date = Date(timeIntervalSince1970: task.data)
        let Dformatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        dataLabel.text = formatter.string(from: date)
        taskTitleTextField.text = task.title
        todoTextView.text = task.todo
    }
    
    private func setupUI() {
        backButton.addTarget(self, action: #selector(openTaskListVC), for: .touchUpInside)
        view.backgroundColor = .systemBackground
        view.addSubview(taskTitleTextField)
        view.addSubview(dataLabel)
        view.addSubview(todoTextView)
        view.addSubview(backButton)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .systemYellow
        backButton.setTitle("Назад", for: .normal)
        backButton.setTitleColor(.systemYellow, for: .normal)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalToSuperview().offset(16)        }
        
        taskTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(16)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        taskTitleTextField.font = .systemFont(ofSize: 30, weight: .bold)
        taskTitleTextField.textAlignment = .center
        todoTextView.font = .systemFont(ofSize: 16, weight: .medium)
        
        dataLabel.snp.makeConstraints { make in
            make.top.equalTo(taskTitleTextField.snp.bottom).offset(8)
            make.left.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        todoTextView.snp.makeConstraints { make in
            make.top.equalTo(dataLabel.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
        
        dataLabel.textColor = .systemGray
        dataLabel.font = .systemFont(ofSize: 12, weight: .thin)
        
    }
    
    @objc func openTaskListVC () {
        output.openTaskListVC()
    }
}
