//
//  ProfileHeaderCell.swift
//  viewstate
//
//  Created by Christopher Trott on 8/12/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import UIKit

final class ProfileHeaderCell: UITableViewCell {
    
    private static let avatarSide: CGFloat = 106
    
    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = Color.gray10
        view.layer.cornerRadius = ceil(ProfileHeaderCell.avatarSide / 2.0)
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
            avatarImageView.widthAnchor.constraint(equalToConstant: ProfileHeaderCell.avatarSide),
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
    
    func configure(with viewModel: ProfileHeaderViewModel) {
        // TODO: imageView url
        avatarImageView.image = nil
        usernameLabel.configure(with: viewModel.username)
        friendsCountLabel.configure(with: viewModel.friendsCount)
    }
}

