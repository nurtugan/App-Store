//
//  AppsHeaderCell.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/9/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit

final class AppsHeaderCell: UICollectionViewCell {
    var socialApp: SocialApp! {
        didSet {
            companyLabel.text = socialApp.name
            titleLabel.text = socialApp.tagline
            imageView.setImage(with: socialApp.imageUrl)
        }
    }
    
    let companyLabel = UILabel(text: "Facebook", font: .boldSystemFont(ofSize: 14))
    let titleLabel = UILabel(text: "Keeping up with friends is faster than ever", font: .systemFont(ofSize: 24))
    let imageView  = UIImageView(cornerRadius: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        companyLabel.textColor = .systemBlue
        titleLabel.numberOfLines = 2
        imageView.contentMode = .scaleAspectFill
        
        let stackView = VerticalStackView(arrangedSubviews: [companyLabel, titleLabel, imageView], spacing: 12)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
