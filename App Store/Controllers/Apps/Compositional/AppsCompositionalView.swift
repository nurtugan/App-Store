//
//  AppsCompositionalView.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/25/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import SwiftUI

enum AppSection {
    case topSocial
    case grossing
    case games
    case topFree
}

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
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<AppSection, AnyHashable> = .init(collectionView: collectionView) { collectionView, indexPath, object -> UICollectionViewCell? in
        if let object = object as? SocialApp {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.headerID, for: indexPath) as! AppsHeaderCell
            cell.socialApp = object
            return cell
        } else if let object = object as? FeedResult {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.defaultCellID, for: indexPath) as! AppRowCell
            cell.app = object
            cell.getButton.addTarget(self, action: #selector(self.handleGet), for: .primaryActionTriggered)
            return cell
        }
        return nil
    }
    
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
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = .init(title: "Fetch Top Free", style: .plain, target: self, action: #selector(handleFetchTopFree))
        
//        fetchApps()
        
        setupDiffableDataSource()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        0
    }
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderID, for: indexPath) as! CompositionalHeader
//        var title: String?
//        switch indexPath.section {
//        case 1:
//            title = gamesGroup?.feed.title
//        case 2:
//            title = topGrossingApps?.feed.title
//        case 3:
//            title = freeApps?.feed.title
//        default:
//            return header
//        }
//        header.label.text = title
//        return header
//    }
    
    // MARK: - Collection View Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var appID = ""
        let object = diffableDataSource.itemIdentifier(for: indexPath)
        if let object = object as? SocialApp {
            appID = object.id
        } else if let object = object as? FeedResult {
            appID = object.id
        }
        let appDetailController = AppDetailController(appID: appID)
        navigationController?.pushViewController(appDetailController, animated: true)
    }
    
    // MARK: - Collection View Diffable Data Source
    private func setupDiffableDataSource() {
        collectionView.dataSource = diffableDataSource
        diffableDataSource.supplementaryViewProvider = .some { collectionView, kind, indexPath -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.sectionHeaderID, for: indexPath) as! CompositionalHeader
            let snapshot = self.diffableDataSource.snapshot()
            let object = self.diffableDataSource.itemIdentifier(for: indexPath)
            let section = snapshot.sectionIdentifier(containingItem: object!)!
            switch section {
            case .games:
                header.label.text = "Games"
            case .grossing:
                header.label.text = "Top Grossing"
            case .topFree:
                header.label.text = "Top Free"
            default:
                break
            }
            return header
        }
        
        Service.shared.fetchSocialApps { socialApps, error in
            Service.shared.fetchTopGrossing { appGroup, error in
                Service.shared.fetchGames { gamesGroup, error in
                    var snapshot = self.diffableDataSource.snapshot()
                    
                    snapshot.appendSections([.topSocial, .games, .grossing])
                    
                    snapshot.appendItems(socialApps ?? [], toSection: .topSocial)
                    
                    let objects = appGroup?.feed.results ?? []
                    snapshot.appendItems(objects, toSection: .grossing)
                    
                    let games = gamesGroup?.feed.results ?? []
                    snapshot.appendItems(games, toSection: .games)
                    
                    self.diffableDataSource.apply(snapshot)
                }
            }
        }
    }
    
    @objc
    private func handleGet(_ sender: UIButton) {
        var superview = sender.superview
        while superview != nil {
            if let cell = superview as? UICollectionViewCell {
                guard let indexPath = collectionView.indexPath(for: cell),
                    let objectIClickedOnto = diffableDataSource.itemIdentifier(for: indexPath) else { return }
                var snapshot = diffableDataSource.snapshot()
                snapshot.deleteItems([objectIClickedOnto])
                diffableDataSource.apply(snapshot)
                break
            }
            superview = superview?.superview
        }
    }
    
    @objc
    private func handleFetchTopFree() {
        Service.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/25/explicit.json") { appGroup, error in
            var snapshot = self.diffableDataSource.snapshot()
            snapshot.insertSections([.topFree], afterSection: .topSocial)
            snapshot.appendItems(appGroup?.feed.results ?? [], toSection: .topFree)
            self.diffableDataSource.apply(snapshot)
        }
    }
    
    @objc
    private func handleRefresh() {
        collectionView.refreshControl?.endRefreshing()
        var snapshot = diffableDataSource.snapshot()
        snapshot.deleteSections([.topFree])
        diffableDataSource.apply(snapshot)
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
