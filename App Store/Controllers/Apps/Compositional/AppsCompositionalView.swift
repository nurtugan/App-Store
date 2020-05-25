//
//  AppsCompositionalView.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/25/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import SwiftUI

final class CompositionalController: UICollectionViewController {
    private let cellID = "cellID"
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .red
        return cell
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
