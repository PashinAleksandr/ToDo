//
//  TaskListTableViewCell.swift
//  ToDoForEM
//
//  Created by Aleksandr Pashin on 08.03.2026.
//

import UIKit
import SnapKit
import RxSwift

class TaskListTableViewCell: UITableViewCell {
    private let title = UILabel()
    private let completed = UIButton()
    private let dataLabel = UILabel()
    private let todoLabel = UILabel()
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        title.font = .systemFont(ofSize: 16, weight: .bold)
        todoLabel.font = .systemFont(ofSize: 14, weight: .regular)
        dataLabel.font = .systemFont(ofSize: 12, weight: .regular)
    }
    
    private func setupLayout() {
        contentView.addSubview(title)
        contentView.addSubview(completed)
        contentView.addSubview(dataLabel)
        contentView.addSubview(todoLabel)
        
        completed.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }
        
        title.snp.makeConstraints{ make in
            make.top.trailing.equalToSuperview().offset(16)
            make.leading.equalTo(completed.snp.trailing).offset(12)
        }
        
        todoLabel.snp.makeConstraints{ make in
            make.leading.equalTo(completed.snp.trailing).offset(12)
            make.top.trailing.equalTo(title).offset(16)
        }
        dataLabel.snp.makeConstraints { make in
            make.top.equalTo(todoLabel).offset(12)
            make.leading.equalTo(completed.snp.trailing).offset(12)
            make.bottom.equalToSuperview().offset(16)
        }
    }
    
    func configure(with viewModel: ViewModel) {
        viewModel.title.bind(to: title.rx.text).disposed(by: disposeBag)
        viewModel.completed.bind(to: completed.rx.isEnabled).disposed(by: disposeBag)
        viewModel.dataLabel.bind(to: dataLabel.rx.text).disposed(by: disposeBag)
        viewModel.todoLabel.bind(to: todoLabel.rx.text).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
