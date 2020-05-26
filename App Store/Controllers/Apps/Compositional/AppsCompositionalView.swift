//
//  AppsCompositionalView.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/25/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import SwiftUI

final class CompositionalController: UICollectionViewController {
    private let headerCellID = "headerCellID"
    private let defaultCellID = "defaultCellID"
    
    private static let cellWidth: CGFloat = 0.8
    
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
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(CompositionalController.cellWidth), heightDimension: .absolute(300)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        
        return section
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: headerCellID)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: defaultCellID)
        
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellID, for: indexPath) as! AppsHeaderCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultCellID, for: indexPath)
            cell.backgroundColor = .blue
            return cell
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
