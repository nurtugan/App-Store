//
//  AppFullscreenController.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/23/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit

final class AppFullscreenController: UIViewController {
    var dismissHandler: (() -> Void)?
    var todayItem: TodayItem?
    
    // MARK: - UI
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close-button"), for: .normal)
        return button
    }()
    let tableView = UITableView(frame: .zero, style: .plain)
    private let floatingContainerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        view.addSubview(tableView)
        tableView.fillSuperview()
        
        setupCloseButton()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = .init(top: 0, left: 0, bottom: 34, right: 0)
        
        setupFloatingControls()
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 16), size: .init(width: 38, height: 38))
    }
    
    private func setupFloatingControls() {
        floatingContainerView.clipsToBounds = true
        floatingContainerView.layer.cornerRadius = 16
        view.addSubview(floatingContainerView)
        floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: -80, right: 16), size: .init(width: 0, height: 80))
        let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        floatingContainerView.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        
        // Subviews
        let imageView = UIImageView(cornerRadius: 8)
        imageView.image = todayItem?.image
        imageView.constrainHeight(constant: 55)
        imageView.constrainWidth(constant: 55)
        
        let getButton = UIButton(title: "GET")
        getButton.setTitleColor(.white, for: .normal)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        getButton.backgroundColor = .darkGray
        getButton.layer.cornerRadius = 16
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [
                UILabel(text: todayItem?.category ?? "", font: .boldSystemFont(ofSize: 18)),
                UILabel(text: todayItem?.title ?? "", font: .systemFont(ofSize: 16))
            ], spacing: 4),
            getButton
        ], customSpacing: 16)
        
        floatingContainerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.alignment = .center
    }
    
    @objc
    private func handleDismiss(_ sender: UIButton) {
        sender.isHidden = true
        dismissHandler?()
    }
}

extension AppFullscreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let header = AppFullscreenHeaderCell()
            header.todayCell.todayItem = todayItem
            header.todayCell.layer.cornerRadius = 0
            header.clipsToBounds = true
            header.todayCell.backgroundView = nil
            return header
        }
        let cell = AppFullscreenDescriptionCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return TodayController.cellSize
        }
        return UITableView.automaticDimension
    }
}

extension AppFullscreenController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
        let translationY = -floatingContainerView.frame.height - statusBarHeight
        let transform = scrollView.contentOffset.y > 100 ? CGAffineTransform(translationX: 0, y: translationY) : .identity
        scrollView.contentInset.bottom = transform == .identity ? 0 : -translationY
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.floatingContainerView.transform = transform
        })
    }
}
