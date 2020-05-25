//
//  TrackCell.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/25/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit

final class TrackCell: UICollectionViewCell {
    private let imageView = UIImageView(cornerRadius: 16)
    private let nameLabel = UILabel(text: "Track Name", font: .boldSystemFont(ofSize: 18))
    private let subTitleLabel = UILabel(text: "Sub Title Label", font: .systemFont(ofSize: 16), numberOfLines: 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.image = #imageLiteral(resourceName: "garden")
        imageView.constrainWidth(constant: 80)
//        imageView.constrainHeight(constant: 80)
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [
                nameLabel,
                subTitleLabel
            ], spacing: 8)
        ], customSpacing: 16)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        stackView.alignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
