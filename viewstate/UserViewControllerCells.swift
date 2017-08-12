//
//  UserViewControllerCells.swift
//  viewstate
//
//  Created by Christopher Trott on 8/9/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import UIKit
import QuartzCore

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
    
    private let loadingAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
        animation.fromValue = Color.gray20.cgColor
        animation.toValue = Color.gray45.cgColor
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0, 0.6, 1)
        return animation
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
            background.heightAnchor.constraint(greaterThanOrEqualToConstant: 22),
            
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
        animate(viewModel.isLoading)
    }
    
    private func animate(_ animate: Bool) {
        let key = "key"
        let isAnimating = background.layer.animation(forKey: key) != nil
        switch (animate, isAnimating) {
        case (true, false):
            background.layer.add(loadingAnimation, forKey: key)
        case (false, true):
            background.layer.removeAnimation(forKey: key)
        case (true, true),
             (false, false):
            break
        }
    }
}

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

final class ContentHeaderCell: UITableViewCell {
    
    private let label: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = Font.style(.title2)
        view.textColor = Color.gray75
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Color.gray00
        
        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: 26, left: 12, bottom: 8, right: 12)
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
    
    func configure(with viewModel: String) {
        label.text = viewModel
    }
}

final class ContentLoadingCell: UITableViewCell {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        view.color = Color.gray75
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Color.white
        
        let stackView = UIStackView(arrangedSubviews: [activityIndicator])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 12, bottom: 20, right: 12)
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
    
    override func prepareForReuse() {
        activityIndicator.startAnimating()
    }
}

final class ContentEmptyCell: UITableViewCell {
    
    private let label: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = Font.style(.title3)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Color.white
        
        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 44, left: 12, bottom: 44, right: 12)
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
    
    func configure(with viewModel: String) {
        label.text = viewModel
    }
}

final class PostCell: UITableViewCell {
    
    private let dateLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = Font.style(.caption1)
        view.textColor = Color.gray60
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bodyLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = Font.style(.body)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Color.white
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel, bodyLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 4
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: PostViewModel) {
        dateLabel.text = viewModel.date
        bodyLabel.text = viewModel.body
    }
}
