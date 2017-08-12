//
//  ErrorCell.swift
//  viewstate
//
//  Created by Christopher Trott on 8/12/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import UIKit

final class ErrorCell: UITableViewCell {
    
    private let label: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = Font.style(.title3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let button: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.font = Font.style(.title3)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Color.gray00
        
        let stackView = UIStackView(arrangedSubviews: [label, button])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.layoutMargins = UIEdgeInsets(top: 30, left: 12, bottom: 30, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: ErrorViewModel) {
        label.text = viewModel.message
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
}

