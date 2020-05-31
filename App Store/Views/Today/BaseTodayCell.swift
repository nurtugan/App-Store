//
//  BaseTodayCell.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/23/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit

class BaseTodayCell: UICollectionViewCell {
    var todayItem: TodayItem!
    
    override var isHighlighted: Bool {
        didSet {
            shouldHighlight(isHighlighted)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundView = UIView()
        
        addSubview(backgroundView!)
        backgroundView?.fillSuperview()
        backgroundView?.backgroundColor = .white
        backgroundView?.layer.cornerRadius = 16
        
        backgroundView?.layer.shadowOpacity = 0.1
        backgroundView?.layer.shadowRadius = 10
        backgroundView?.layer.shadowOffset = .init(width: 0, height: 10)
        backgroundView?.layer.shouldRasterize = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func shouldHighlight(_ isHighlighted: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = isHighlighted ? .init(scaleX: 0.9, y: 0.9) : .identity
        })
    }
}
