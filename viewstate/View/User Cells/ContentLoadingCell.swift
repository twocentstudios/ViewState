//
//  ContentLoadingCell.swift
//  viewstate
//
//  Created by Christopher Trott on 8/12/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import UIKit

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
