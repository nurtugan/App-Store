//
//  TodayController.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/22/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit

final class TodayController: BaseListController {
    // MARK: - Properties
    private var appFullscreenController: AppFullscreenController!
    private var items: [TodayItem] = []
    
    // MARK: - Static properties
    static let cellSize: CGFloat = 500
    
    // MARK: - Animation properties
    private var startingFrame: CGRect?
    private var anchoredConstraint: AnchoredConstraints?
    private var appFullScreenBeginOffsetY: CGFloat = 0
    
    // MARK: - UI
    private let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .darkGray
        aiv.startAnimating()
        return aiv
    }()
    private let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
        
        collectionView.backgroundColor = .systemGray6
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    // MARK: - Collection View Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.item]
        let cellID = item.cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BaseTodayCell
        cell.todayItem = item
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        return cell
    }
    
    // MARK: - Collection View Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch items[indexPath.item].cellType {
        case .multiple:
            presentTodayMultipleAppsController(for: indexPath)
        case .single:
            showSingleAppFullScreen(for: indexPath)
        }
    }
    
    @objc
    private func handleAppFullScreenDismissal() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.blurVisualEffectView.alpha = 0
            self.appFullscreenController.view.transform = .identity
            self.appFullscreenController.tableView.contentOffset = .zero
            guard let startingFrame = self.startingFrame else { return }
            
            self.anchoredConstraint?.top?.constant = startingFrame.origin.y
            self.anchoredConstraint?.leading?.constant = startingFrame.origin.x
            self.anchoredConstraint?.width?.constant = startingFrame.width
            self.anchoredConstraint?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded() // Starts animation
            self.setTabBarHidden(false) // Showing tab bar
            self.updateTodayCellTopConstraint(constant: 24, closeButtonAlpha: 0) // Updating today cell's top constraint
        }, completion: { _ in
            self.appFullscreenController.view.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    @objc
    private func handleMultipleAppsTap(_ gesture: UITapGestureRecognizer) {
        let collectionView = gesture.view
        var superview = collectionView?.superview
        while superview != nil {
            if let cell = superview as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                presentTodayMultipleAppsController(for: indexPath)
                return
            }
            superview = superview?.superview
        }
    }
    
    private func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        if animated {
            if let frame = tabBarController?.tabBar.frame {
                let factor: CGFloat = hidden ? 1 : -1
                let y = frame.origin.y + (frame.size.height * factor)
                UIView.animate(withDuration: duration, animations: {
                    self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                })
                return
            }
        }
        self.tabBarController?.tabBar.isHidden = hidden
    }
    
    private func updateTodayCellTopConstraint(constant: CGFloat, closeButtonAlpha: CGFloat) {
        guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
        appFullscreenController.closeButton.alpha = closeButtonAlpha
        cell.todayCell.topConstraint.constant = constant
        cell.layoutIfNeeded()
    }
    
    private func presentTodayMultipleAppsController(for indexPath: IndexPath) {
        let fullscreenController = TodayMultipleAppsController(mode: .fullScreen)
        fullscreenController.apps = items[indexPath.item].apps
        let nav = BackEnabledNavigationController(rootViewController: fullscreenController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    private func setupSingleAppFullScreen(for indexPath: IndexPath) {
        let appFullscreenController = AppFullscreenController()
        appFullscreenController.dismissHandler = { [weak self] in self?.handleAppFullScreenDismissal() }
        appFullscreenController.todayItem = items[indexPath.row]
        appFullscreenController.view.layer.cornerRadius = 16
        self.appFullscreenController = appFullscreenController
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        panGesture.delegate = self
        appFullscreenController.view.addGestureRecognizer(panGesture)
    }
    
    @objc
    private func handleDrag(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            appFullScreenBeginOffsetY = appFullscreenController.tableView.contentOffset.y
        }
        if appFullscreenController.tableView.contentOffset.y > 0 {
            return
        }
        let translationY = gesture.translation(in: appFullscreenController.view).y
        switch gesture.state {
        case .changed:
            guard translationY > 0 else { return }
            let trueOffset = translationY - appFullScreenBeginOffsetY
            var scale = 1 - trueOffset / 1000
            scale = min(1, scale)
            scale = max(0.83, scale)
            let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
            appFullscreenController.view.transform = transform
        case .ended:
            guard translationY > 0 else { return }
            handleAppFullScreenDismissal()
        default:
            break
        }
    }
    
    private func setupStartingCellFrame(for indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath),
            let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
    }
    
    private func setupAppFullScreenStartingPosition(for indexPath: IndexPath) {
        let fullscreenView = appFullscreenController.view!
        view.addSubview(fullscreenView)
        addChild(appFullscreenController)
        self.collectionView.isUserInteractionEnabled = false
        
        setupStartingCellFrame(for: indexPath)
        guard let startingFrame = startingFrame else { return }
        
        // MARK: - Configuring constraints
        anchoredConstraint = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
        view.layoutIfNeeded()
    }
    
    private func beginAnimationAppFullScreen() {
        // MARK: - Animating constraints
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.blurVisualEffectView.alpha = 1
            self.anchoredConstraint?.top?.constant = 0
            self.anchoredConstraint?.leading?.constant = 0
            self.anchoredConstraint?.width?.constant = self.view.frame.width
            self.anchoredConstraint?.height?.constant = self.view.frame.height
            self.view.layoutIfNeeded() // Starts animation
            self.setTabBarHidden(true) // Hiding tab bar
            self.updateTodayCellTopConstraint(constant: 48, closeButtonAlpha: 1) // Updating today cell's top constraint
        }, completion: nil)
    }
    
    private func showSingleAppFullScreen(for indexPath: IndexPath) {
        setupSingleAppFullScreen(for: indexPath)
        setupAppFullScreenStartingPosition(for: indexPath)
        beginAnimationAppFullScreen()
    }
    
    // MARK: - Networking
    private func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        var topGrossingGroup: AppGroup?
        var gamesGroup: AppGroup?
        
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { appGroup, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            topGrossingGroup = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchGames { appGroup, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            gamesGroup = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicatorView.stopAnimating()
            self.items = [
                TodayItem(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .single, apps: []),
                TodayItem(category: "THE DAILY LIST", title: topGrossingGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: topGrossingGroup?.feed.results ?? []),
                TodayItem(category: "THE DAILY LIST", title: gamesGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: gamesGroup?.feed.results ?? []),
                TodayItem(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9853100181, green: 0.9683170915, blue: 0.7212222219, alpha: 1), cellType: .single, apps: [])
            ]
            self.collectionView.reloadData()
        }
    }
}

extension TodayController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width - 64, height: TodayController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}

extension TodayController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
