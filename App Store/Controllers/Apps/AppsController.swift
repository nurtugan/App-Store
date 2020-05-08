//
//  AppsController.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/9/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit

final class AppsController: BaseListController {
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .systemYellow
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    // MARK: - CV Data source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AppsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width, height: 250)
    }
}
