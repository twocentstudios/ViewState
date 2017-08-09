//
//  UserViewControllerCells.swift
//  viewstate
//
//  Created by Christopher Trott on 8/9/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import UIKit

final class LoadingTextView: UIView {
    
    private let label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        return view
    }()
    
    private let background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.gray20
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(background)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: LoadingTextViewModel) {
        label.isHidden = viewModel.isLoading
        label.attributedText = viewModel.text
        background.isHidden = !viewModel.isLoading
    }
}

final class ProfileHeaderCell: UITableViewCell {
    
    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = Color.gray10
        return view
    }()
    
    private let usernameLabel: LoadingTextView = {
        let view = LoadingTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let friendsCountLabel: LoadingTextView = {
        let view = LoadingTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Color.gray00
        
        let labelStackView = UIStackView(arrangedSubviews: [usernameLabel, friendsCountLabel])
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .vertical
        labelStackView.alignment = .fill
        labelStackView.spacing = 2
        
        let stackView = UIStackView(arrangedSubviews: [avatarImageView, labelStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 106),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.layer.cornerRadius = ceil(avatarImageView.bounds.width / 2.0)
    }
    
    func configure(with viewModel: ProfileHeaderViewModel) {
        // TODO: imageView url
        usernameLabel.configure(with: viewModel.username)
        friendsCountLabel.configure(with: viewModel.friendsCount)
    }
}