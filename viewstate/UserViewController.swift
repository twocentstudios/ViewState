//
//  UserViewController.swift
//  viewstate
//
//  Created by Christopher Trott on 8/8/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class UserViewController: UIViewController {
    
    let interactor: UserInteractor
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
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
        
        let cell: UITableViewCell
        switch cellViewModelType {
        case .profileHeader(let cellViewModel):
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            cell.textLabel?.attributedText = cellViewModel.username.text
            cell.detailTextLabel?.attributedText = cellViewModel.friendsCount.text
        case .profileError(let cellViewModel):
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            cell.textLabel?.text = cellViewModel.message
            cell.detailTextLabel?.text = cellViewModel.actionTitle
        case .profileAttribute(let cellViewModel):
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            cell.textLabel?.text = cellViewModel.value
            cell.detailTextLabel?.text = cellViewModel.name
        case .contentHeader(let cellViewModel):
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            cell.textLabel?.text = cellViewModel
        case .contentLoading:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            cell.textLabel?.text = "Loading..."
        case .contentEmpty(let cellViewModel):
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            cell.textLabel?.text = cellViewModel
        case .contentError(let cellViewModel):
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            cell.textLabel?.text = cellViewModel.message
            cell.detailTextLabel?.text = cellViewModel.actionTitle
        case .post(let cellViewModel):
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            cell.textLabel?.text = cellViewModel.body
            cell.detailTextLabel?.text = cellViewModel.date
        }
        
        return cell
    }
}
