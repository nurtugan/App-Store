//
//  MultipleAppCell.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/23/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit

final class MultipleAppCell: UICollectionViewCell {
    var app: FeedResult! {
        didSet {
            nameLabel.text = app.name
            companyLabel.text = app.artistName
            imageView.setImage(with: app.artworkUrl100)
        }
    }
    private let imageView = UIImageView(cornerRadius: 10)
    private let nameLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 16), numberOfLines: 2)
    private let companyLabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 12))
    private let getButton = UIButton(title: "GET")
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.constrainWidth(constant: 64)
        imageView.constrainHeight(constant: 64)
        
        getButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        getButton.layer.cornerRadius = 16
        getButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [nameLabel, companyLabel], spacing: 4),
            getButton
        ])
        stackView.spacing = 16
        stackView.alignment = .center
        addSubview(stackView)
        stackView.fillSuperview()
        
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -8, right: 0), size: .init(width: 0, height: 0.5))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
