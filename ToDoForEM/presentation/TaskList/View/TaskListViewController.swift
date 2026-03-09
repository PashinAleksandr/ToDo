//
//  TaskListViewController.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxRelay

class TaskListViewController: UIViewController, TaskListViewInput {
    
    private var taskList: [TODO] = []
    private var taskViewModel: [TaskListTableViewCell.ViewModel] = []
    var output: TaskListViewOutput!
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let searchBar = UISearchBar()
    private let taskLabel = UILabel()
    private let viewContayner = UIView()
    private let taskCounterLabel = UILabel()
    private let creatTaskButton = UIButton()
    
    var d: TODO = TODO(title: "Жрать", todo: "Покорми кота", completed: false, data: 1234.124, id: 1, userID: 1)
    var a: TODO = TODO(title: "Жрать", todo: "Покорми кота", completed: false, data: 1234.124, id: 1, userID: 1)
    var b: TODO = TODO(title: "Жрать", todo: "Покорми кота", completed: false, data: 1234.124, id: 1, userID: 1)
    var c: TODO = TODO(title: "Жрать", todo: "Покорми кота", completed: false, data: 1234.124, id: 1, userID: 1)
    var e: TODO = TODO(title: "Жрать", todo: "Покорми кота", completed: false, data: 1234.124, id: 1, userID: 1)
    var t: TODO = TODO(title: "Жрать", todo: "Покорми кота", completed: false, data: 1234.124, id: 1, userID: 1)
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        taskList = [a,b,c,d,e,t]
        transform(tasks: taskList)
        setupInitialState()
    }


    // MARK: TaskListViewInput
    func setupInitialState() {
        output.viewIsReady()
        setupActivityIndicator()
        activityIndicator.startAnimating()
        setuUI()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func transform(tasks: [TODO]) {
        tasks.forEach { task in
            var vc: TaskListTableViewCell.ViewModel = TaskListTableViewCell.ViewModel(task: task)
            taskViewModel.append(vc)
        }
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func setuUI() {
        title = "Задачи"
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskListTableViewCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        view.addSubview(searchBar)
       
        
    }
}


extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TaskListTableViewCell.self, indexPath: indexPath)
        let vm = taskViewModel[indexPath.row]
        cell.configure(with: vm)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        output.didSelectTask(task)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
