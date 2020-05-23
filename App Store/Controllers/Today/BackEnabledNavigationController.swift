//
//  BackEnabledNavigationController.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/24/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import UIKit

final class BackEnabledNavigationController: UINavigationController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        interactivePopGestureRecognizer?.delegate = self
    }
}

extension BackEnabledNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
