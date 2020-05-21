//
//  AppDetailCell.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/12/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit

final class AppDetailCell: UICollectionViewCell {
    
    var app: Result! {
        didSet {
            nameLabel.text = app?.trackName
            releaseNotesLabel.text = app?.releaseNotes
            appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
            priceButton.setTitle(app?.formattedPrice, for: .normal)
        }
    }
    
    let appIconImageView = UIImageView(cornerRadius: 16)
    
    let nameLabel = UILabel(text: "App Name", font: .boldSystemFont(ofSize: 24), numberOfLines: 2)
    
    let priceButton = UIButton(title: "$4.99")
    
    let whatsNewLabel = UILabel(text: "What's New", font: .boldSystemFont(ofSize: 20))
    
    let releaseNotesLabel = UILabel(text: "Release Notes", font: .systemFont(ofSize: 18), numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        appIconImageView.constrainWidth(constant: 140)
        appIconImageView.constrainHeight(constant: 140)
        
        priceButton.backgroundColor = .systemBlue
        priceButton.constrainHeight(constant: 32)
        priceButton.layer.cornerRadius = 32 / 2
        priceButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        priceButton.setTitleColor(.white, for: .normal)
        priceButton.constrainWidth(constant: 80)
        
        let stackView = VerticalStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [
                appIconImageView,
                VerticalStackView(arrangedSubviews: [
                    nameLabel,
                    UIStackView(arrangedSubviews: [priceButton, UIView()]),
                    UIView()
                ], spacing: 12)
            ], customSpacing: 20),
            whatsNewLabel,
            releaseNotesLabel
        ], spacing: 16)
        addSubview(stackView)
        let padding: CGFloat = 20
        stackView.fillSuperview(padding: .init(top: padding, left: padding, bottom: padding, right: padding))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
