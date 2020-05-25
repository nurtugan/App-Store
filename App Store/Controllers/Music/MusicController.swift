//
//  MusicController.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/24/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit

final class MusicController: BaseListController {
    private let cellID = "cellID"
    private let footerID = "footerID"
    
    private var results: [Result] = []
    private let searchTerm = "taylor"
    private var isPaginating = false
    private var isDonePaginating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(MusicLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerID)
        fetchData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        results.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! TrackCell
        let track = results[indexPath.item]
        cell.nameLabel.text = track.trackName
        cell.imageView.sd_setImage(with: URL(string: track.artworkUrl100))
        cell.subTitleLabel.text = "\(track.artistName ?? "") • \(track.collectionName ?? "")"
        
        if indexPath.item == results.count - 1 && !isPaginating {
            isPaginating = true
            let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=\(results.count)&limit=20"
            Service.shared.fetchGenericJSONData(urlString: urlString) { [weak self] (searchResult: SearchResult?, error) in
                guard let self = self else {
                    assertionFailure()
                    return
                }
                if let error = error {
                    print("Failed to paginate data: \(error.localizedDescription)")
                    return
                }
                if searchResult?.results.count == 0 {
                    self.isDonePaginating = true
                }
                sleep(2)
                self.results += searchResult?.results ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                self.isPaginating = false
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerID, for: indexPath) as! MusicLoadingFooter
        return footer
    }
    
    private func fetchData() {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=0&limit=20"
        Service.shared.fetchGenericJSONData(urlString: urlString) { [weak self] (searchResult: SearchResult?, error) in
            guard let self = self else {
                assertionFailure()
                return
            }
            if let error = error {
                print("Failed to paginate data: \(error.localizedDescription)")
                return
            }
            self.results = searchResult?.results ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension MusicController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = isDonePaginating ? 0 : 100
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}
