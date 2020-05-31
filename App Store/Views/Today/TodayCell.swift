//
//  TodayCell.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/22/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit

final class TodayCell: BaseTodayCell {
    // MARK: - DI
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            imageView.image = todayItem.image
            descriptionLabel.text = todayItem.description
            backgroundColor = todayItem.backgroundColor
            backgroundView?.backgroundColor = todayItem.backgroundColor
        }
    }
    
    // MARK: - UI Elements
    private let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    private let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 28))
    private let imageView = UIImageView(image: #imageLiteral(resourceName: "garden"))
    private let descriptionLabel = UILabel(text: "All the tools and apps you need to intelligently organize your life the right way.", font: .systemFont(ofSize: 16), numberOfLines: 3)
    
    var topConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .tertiarySystemBackground
        layer.cornerRadius = 16

        let imageContainerView = UIView()
        imageContainerView.addSubview(imageView)
        imageContainerView.clipsToBounds = true
        imageView.centerInSuperview(size: .init(width: 240, height: 240))

        imageView.contentMode = .scaleAspectFill
        let stackView = VerticalStackView(arrangedSubviews: [
            categoryLabel, titleLabel, imageContainerView, descriptionLabel
        ], spacing: 8)
        addSubview(stackView)
        stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 24, bottom: 24, right: 24))
        self.topConstraint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        self.topConstraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
