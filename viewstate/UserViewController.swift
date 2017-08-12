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
import Diff

class UserViewController: UIViewController {
    
    let interactor: UserInteractor
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Color.gray00
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self)
        tableView.register(ProfileHeaderCell.self)
        tableView.register(ErrorCell.self)
        tableView.register(ProfileAttributeCell.self)
        tableView.register(ContentHeaderCell.self)
        tableView.register(ContentLoadingCell.self)
        tableView.register(ContentEmptyCell.self)
        tableView.register(PostCell.self)
        return tableView
    }()
    
    init(interactor: UserInteractor) {
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Profile"
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
            .map { $0.viewModels }
            .scan([], { [unowned self] (old, new) -> [UserViewModel.ViewModelType] in
                self.tableView.animateRowChanges(oldData: old, newData: new, deletionAnimation: .fade, insertionAnimation: .fade)
                return new
            })
            .start()
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
            let cell = tableView.dequeue(ProfileAttributeCell.self, for: indexPath)
            cell.configure(with: cellViewModel)
            returnCell = cell
        case .contentHeader(let cellViewModel):
            let cell = tableView.dequeue(ContentHeaderCell.self, for: indexPath)
            cell.configure(with: cellViewModel)
            returnCell = cell
        case .contentLoading:
            let cell = tableView.dequeue(ContentLoadingCell.self, for: indexPath)
            returnCell = cell
        case .contentEmpty(let cellViewModel):
            let cell = tableView.dequeue(ContentEmptyCell.self, for: indexPath)
            cell.configure(with: cellViewModel)
            returnCell = cell
        case .contentError(let cellViewModel):
            let cell = tableView.dequeue(ErrorCell.self, for: indexPath)
            cell.configure(with: cellViewModel)
            cell.button.reactive.controlEvents(.touchUpInside)
                .take(until: cell.reactive.prepareForReuse)
                .observeValues({ [unowned self] _ in
                    self.interactor.commandSink.send(value: .loadPosts)
                })
            returnCell = cell
        case .post(let cellViewModel):
            let cell = tableView.dequeue(PostCell.self, for: indexPath)
            cell.configure(with: cellViewModel)
            returnCell = cell
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
