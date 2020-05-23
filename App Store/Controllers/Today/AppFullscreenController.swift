//
//  AppFullscreenController.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/23/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit

final class AppFullscreenController: UITableViewController {
    var dismissHandler: (() -> Void)?
    var todayItem: TodayItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = .init(top: 0, left: 0, bottom: 34, right: 0)
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let header = AppFullscreenHeaderCell()
            header.closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            header.todayCell.todayItem = todayItem
            header.todayCell.layer.cornerRadius = 0
            return header
        }
        let cell = AppFullscreenDescriptionCell()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 450
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    @objc
    private func handleDismiss(_ sender: UIButton) {
        sender.isHidden = true
        dismissHandler?()
    }
}
