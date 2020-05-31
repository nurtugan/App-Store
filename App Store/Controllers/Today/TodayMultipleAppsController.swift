//
//  TodayMultipleAppsController.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/23/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit

final class TodayMultipleAppsController: BaseListController {
    enum Mode {
        case small, fullScreen
    }
    
    private let cellID = "cellID"
    private let spacing: CGFloat = 16
    private let mode: Mode
    
    var apps: [FeedResult] = [] { didSet { collectionView.reloadData() } }
    
    // MARK: - UI
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close-button"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    override var prefersStatusBarHidden: Bool { true }
    
    init(mode: Mode) {
        self.mode = mode
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode == .fullScreen {
            setupCloseButton()
        } else {
            collectionView.isScrollEnabled = false
        }
        collectionView.backgroundColor = .tertiarySystemBackground
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch mode {
        case .small:
            return min(4, apps.count)
        case .fullScreen:
            return apps.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MultipleAppCell
        cell.app = apps[indexPath.item]
        return cell
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 16), size: .init(width: 38, height: 38))
    }
    
    @objc
    private func handleDismiss() {
        dismiss(animated: true)
    }
}

extension TodayMultipleAppsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = view.frame.width
        if mode == .fullScreen {
            return .init(width: viewWidth - 48, height: 74)
        }
        let height: CGFloat = (view.frame.height - 3 * spacing) / 4
        return .init(width: viewWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if mode == .fullScreen {
            return .init(top: 16, left: 24, bottom: 16, right: 24)
        }
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appID = apps[indexPath.row].id
        let appDetailController = AppDetailController(appID: appID)
        navigationController?.pushViewController(appDetailController, animated: true)
    }
}
