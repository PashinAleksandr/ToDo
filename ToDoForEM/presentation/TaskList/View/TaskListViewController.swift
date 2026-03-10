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
    
    private var taskList: [Task] = []
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
    private let micImage = UIImage(systemName: "mic.fill")
    private let micImageView = UIImageView()
    
//    var d: Task = Task(title: "ЖратьПокорми котаПокорми кота", todo: "Покорми кота Покорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми кота", completed: false, data: 1234.124, id: 1, userID: 1)
//    var a: Task = Task(title: "ЖратПокорми котаПокорми котаПокорми котаПокорми котаь", todo: "Покорми кота", completed: false, data: 1234.124, id: 1, userID: 1)
//    var b: Task = Task(title: "ЖратПокорми котаь", todo: "Покорми кота", completed: false, data: 1234.124, id: 1, userID: 1)
//    var c: Task = Task(title: "Жрать", todo: "ПокоПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котаПокорми котарми кота", completed: false, data: 1234.124, id: 1, userID: 1)
//    var e: Task = Task(title: "Жрать", todo: "Покорми кота", completed: false, data: 1234.124, id: 1, userID: 1)
//    var t: Task = Task(title: "Жрать", todo: "Покорми кота", completed: false, data: 1234.124, id: 1, userID: 1)
//    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       // taskList = [a,b,c,d,e,t]
      //  transform(tasks: taskList)
        setupInitialState()
    }
    
    
    // MARK: TaskListViewInput
    func setupInitialState() {
        //  output.viewIsReady()
        setupActivityIndicator()
        activityIndicator.startAnimating()
        setuUI()
        output.loadTask()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func showTasks(_ tasks: [Task]) {

        var map = Dictionary(uniqueKeysWithValues: taskList.map { ($0.id, $0) })

        for task in tasks {
            map[task.id] = task
        }

        taskList = Array(map.values)

        transform(tasks: taskList)

        stopActivityIndicator()
        tableView.reloadData()
    }
    
    func transform(tasks: [Task]) {
        taskViewModel = tasks.map {
            TaskListTableViewCell.ViewModel(task: $0)
        }
    }
    
    func deleteTask(taskRow: Int) {
        taskList.remove(at: taskRow)
        taskViewModel.remove(at: taskRow)
        tableView.reloadData()
        taskCounterLabel.text = "\(taskViewModel.count) Задач"
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func setuUI() {
        title = "Задачи"
        view.backgroundColor = .systemBackground
        view.addSubview(taskLabel)
        taskLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        taskLabel.text = "Задачи"
        taskLabel.font = .systemFont(ofSize: 30, weight: .bold)
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(taskLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        taskLabel.textAlignment = .left
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskListTableViewCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(searchBar.snp.bottom).offset(16)        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        searchBar.placeholder = "Search"
        searchBar.addSubview(micImageView)
        micImageView.image = micImage
        micImageView.tintColor = .systemGray
        micImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        micImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(searchBar)
        }
        searchBar.searchTextField.rightView = micImageView
        searchBar.searchTextField.rightViewMode = .always
        
        view.addSubview(viewContayner)
        
        viewContayner.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
        }
        
        viewContayner.addSubview(taskCounterLabel)
        viewContayner.backgroundColor = .systemGray
        taskCounterLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        viewContayner.addSubview(creatTaskButton)
        creatTaskButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(taskCounterLabel)
            make.width.height.equalTo(36)
        }
        
        taskCounterLabel.font = .systemFont(ofSize: 16, weight: .medium)
        taskCounterLabel.textColor = .systemGray6
        taskCounterLabel.text = "\(taskViewModel.count) Задач"
        creatTaskButton.addTarget(self, action: #selector(creatNewTask), for: .touchUpInside)
        creatTaskButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        creatTaskButton.tintColor = .systemYellow
        creatTaskButton.configuration = .plain()
        creatTaskButton.configuration?.preferredSymbolConfigurationForImage =
        UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        
    }
    
    @objc func creatNewTask() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let timestamp = today.timeIntervalSince1970

        
        let newTask: Task = Task(title: "", todo: "", completed: false, data: timestamp, id: taskList.count+1 , userID: 99)
        output.didSelectTask(newTask)
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
    
    func editTask(index: Int) {
        output.didSelectTask(taskList[index])
    }
}

extension TaskListViewController {
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { _ in
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { action in
                self.editTask(index: indexPath.row)
            }
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                self.deleteTask(taskRow: indexPath.row)
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { action in
                
            }
            
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
}
