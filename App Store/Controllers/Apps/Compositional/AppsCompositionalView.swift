//
//  AppsCompositionalView.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/25/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import SwiftUI

final class CompositionalHeader: UICollectionReusableView {
    let label = UILabel(text: "Editor's Choise Games", font: .boldSystemFont(ofSize: 32))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

final class CompositionalController: UICollectionViewController {
    private let headerID = "headerID"
    private let defaultCellID = "defaultCellID"
    private let sectionHeaderID = "sectionHeaderID"
    
    private static let cellWidth: CGFloat = 0.9
    
    private var socialApps: [SocialApp] = []
    private var gamesGroup: AppGroup?
    private var topGrossingApps: AppGroup?
    private var freeApps: AppGroup?
    
    init() {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionNumber, _ -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                return CompositionalController.topSection()
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
                item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(CompositionalController.cellWidth), heightDimension: .absolute(300)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets.leading = 16
                
                let kind = UICollectionView.elementKindSectionHeader
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: kind, alignment: .topLeading)
                ]
                
                return section
            }
        })
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Static methods
    private static func topSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.bottom = 16
        item.contentInsets.trailing = 16
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(CompositionalController.cellWidth), heightDimension: .absolute(325)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        
        return section
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: headerID)
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: defaultCellID)
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderID)
        
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchApps()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return socialApps.count
        case 1:
            return gamesGroup?.feed.results.count ?? 0
        case 2:
            return topGrossingApps?.feed.results.count ?? 0
        case 3:
            return freeApps?.feed.results.count ?? 0
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerID, for: indexPath) as! AppsHeaderCell
            let socialApp = socialApps[indexPath.item]
            cell.companyLabel.text = socialApp.tagline
            cell.titleLabel.text = socialApp.name
            cell.imageView.sd_setImage(with: URL(string: socialApp.imageUrl))
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultCellID, for: indexPath) as! AppRowCell
            var appGroup: AppGroup?
            switch indexPath.section {
            case 1:
                appGroup = gamesGroup
            case 2:
                appGroup = topGrossingApps
            case 3:
                appGroup = freeApps
            default:
                return cell
            }
            cell.app = appGroup?.feed.results[indexPath.item]
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderID, for: indexPath) as! CompositionalHeader
        var title: String?
        switch indexPath.section {
        case 1:
            title = gamesGroup?.feed.title
        case 2:
            title = topGrossingApps?.feed.title
        case 3:
            title = freeApps?.feed.title
        default:
            return header
        }
        header.label.text = title
        return header
    }
    
    // MARK: - Collection View Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appID: String
        switch indexPath.section {
        case 0:
            appID = socialApps[indexPath.item].id
        case 1:
            appID = gamesGroup?.feed.results[indexPath.item].id ?? ""
        case 2:
            appID = topGrossingApps?.feed.results[indexPath.item].id ?? ""
        case 3:
            appID = freeApps?.feed.results[indexPath.item].id ?? ""
        default:
            return
        }
        let appDetailController = AppDetailController(appID: appID)
        navigationController?.pushViewController(appDetailController, animated: true)
    }
    
    private func fetchApps() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchGames { appGroup, error in
            self.gamesGroup = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { appGroup, error in
            self.topGrossingApps = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/25/explicit.json") { appGroup, error in
            self.freeApps = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchSocialApps { apps, error in
            dispatchGroup.leave()
            self.socialApps = apps ?? []
        }
        
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
}

struct AppsView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = CompositionalController()
        controller.view.backgroundColor = .systemRed
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct AppsCompositionalView_Previews: PreviewProvider {
    static var previews: some View {
        AppsView().edgesIgnoringSafeArea(.all)
    }
}
