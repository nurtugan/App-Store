//
//  AppsSearchController.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/1/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit
import SDWebImage

final class AppsSearchController: UICollectionViewController {
    
    private let cellID = "CellID"
    private var appResults: [Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = . white
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellID)
        
        fetchITunesApps()
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Collection View Data Source
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SearchResultCell
        cell.appResult = appResults[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        appResults.count
    }
    
    // MARK: - Networking
    private func fetchITunesApps() {
        Service.shared.fetchApps { [weak self] results, error in
            if let error = error {
                print(error)
                return
            }
            guard let self = self else {
                assertionFailure()
                return
            }
            self.appResults = results
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - Collection View Delegate Flow Layout
extension AppsSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: 350)
    }
}
