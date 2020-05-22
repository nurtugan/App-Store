//
//  ReviewCell.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/22/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit

final class ReviewCell: UICollectionViewCell {
    let titleLabel = UILabel(text: "Review title", font: .boldSystemFont(ofSize: 18))
    
    let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 16))
    
    let starsStackView: UIStackView = {
        var arrangedSubviews: [UIView] = []
        (0..<5).forEach { _ in
            let imageView = UIImageView(image: #imageLiteral(resourceName: "star"))
            imageView.constrainWidth(constant: 20)
            imageView.constrainHeight(constant: 20)
            arrangedSubviews.append(imageView)
        }
        arrangedSubviews.append(UIView())
        let sv = UIStackView(arrangedSubviews: arrangedSubviews)
        return sv
    }()
    
    let bodyLabel = UILabel(text: "Review body\nReview body\nReview body\nReview body\n", font: .systemFont(ofSize: 18), numberOfLines: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.systemGray6
        layer.cornerRadius = 16
        clipsToBounds = true
        
        let stackView = VerticalStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [titleLabel, authorLabel], customSpacing: 8),
            starsStackView,
            bodyLabel
        ], spacing: 12)
        
        titleLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
        authorLabel.textAlignment = .right
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
