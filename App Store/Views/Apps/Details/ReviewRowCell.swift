//
//  ReviewRowCell.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/22/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit

final class ReviewRowCell: UICollectionViewCell {
    private let titleLabel = UILabel(text: "Reviews & Rating", font: .boldSystemFont(ofSize: 20))
    let reviewsController = ReviewsController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(reviewsController.view)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: reviewsController.view.topAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 20, bottom: 16, right: 20))
        reviewsController.view.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
