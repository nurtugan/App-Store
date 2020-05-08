//
//  BaseListController.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/9/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit

class BaseListController: UICollectionViewController {
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
