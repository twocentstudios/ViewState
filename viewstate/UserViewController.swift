//
//  UserViewController.swift
//  viewstate
//
//  Created by Christopher Trott on 8/8/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class UserViewController: UIViewController {
    
    let interactor: UserInteractor
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.register(UITableViewCell.self)
        tableView.register(ProfileHeaderCell.self)
        tableView.register(ErrorCell.self)
        return tableView
    }()
    
    init(interactor: UserInteractor) {
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        interactor.viewModel.producer
            .skipRepeats()
            .startWithValues { [weak self] _ in
                self?.tableView.reloadData()
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        interactor.commandSink.send(value: .loadPosts)
        interactor.commandSink.send(value: .loadProfile)
    }
}

extension UserViewController: UITableViewDelegate {
    
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.viewModel.value.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModelType = interactor.viewModel.value.viewModel(at: indexPath) else { fatalError() }
        
        let returnCell: UITableViewCell
        switch cellViewModelType {
        case .profileHeader(let cellViewModel):
            let cell = tableView.dequeue(ProfileHeaderCell.self, for: indexPath)
            cell.configure(with: cellViewModel)
            returnCell = cell
        case .profileError(let cellViewModel):
            let cell = tableView.dequeue(ErrorCell.self, for: indexPath)
            cell.configure(with: cellViewModel)
            cell.button.reactive.controlEvents(.touchUpInside)
                .take(until: cell.reactive.prepareForReuse)
                .observeValues({ [unowned self] _ in
                    self.interactor.commandSink.send(value: .loadProfile)
                })
            returnCell = cell
        case .profileAttribute(let cellViewModel):
            returnCell = tableView.dequeue(UITableViewCell.self, for: indexPath)
            returnCell.textLabel?.text = cellViewModel.value
            returnCell.detailTextLabel?.text = cellViewModel.name
        case .contentHeader(let cellViewModel):
            returnCell = tableView.dequeue(UITableViewCell.self, for: indexPath)
            returnCell.textLabel?.text = cellViewModel
        case .contentLoading:
            returnCell = tableView.dequeue(UITableViewCell.self, for: indexPath)
            returnCell.textLabel?.text = "Loading..."
        case .contentEmpty(let cellViewModel):
            returnCell = tableView.dequeue(UITableViewCell.self, for: indexPath)
            returnCell.textLabel?.text = cellViewModel
        case .contentError(let cellViewModel):
            returnCell = tableView.dequeue(UITableViewCell.self, for: indexPath)
            returnCell.textLabel?.text = cellViewModel.message
            returnCell.detailTextLabel?.text = cellViewModel.actionTitle
        case .post(let cellViewModel):
            returnCell = tableView.dequeue(UITableViewCell.self, for: indexPath)
            returnCell.textLabel?.text = cellViewModel.body
            returnCell.detailTextLabel?.text = cellViewModel.date
        }
        
        return returnCell
    }
}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        self.register(T.self, forCellReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }
    
    func dequeue<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self),
                                             for: indexPath) as? T
            else { fatalError("Could not deque cell with type \(T.self)") }
        
        return cell
    }
}
