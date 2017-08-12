//
//  ProfileAttributeCell.swift
//  viewstate
//
//  Created by Christopher Trott on 8/12/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import UIKit

final class ProfileAttributeCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .right
        view.font = Font.style(.body)
        view.textColor = Color.gray60
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let valueLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = Font.style(.headline)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Color.white
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, valueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 20
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: ProfileAttributeViewModel) {
        nameLabel.text = viewModel.name
        valueLabel.text = viewModel.value
    }
}

