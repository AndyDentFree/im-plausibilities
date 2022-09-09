//
// Created by Andrew Dent on 2019-01-01.
// Copyright (c) 2019 Touchgram Pty Ltd. All rights reserved.
//

import Foundation
import UIKit

protocol HostingVC where Self: UIViewController {
    func hostVC(_ vc:UIViewController)
    func removeAllChildViewControllers()
}

extension HostingVC {
    func hostVC(_ vc:UIViewController) {
        addChild(vc)

        vc.view.frame = view.bounds
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vc.view)

        vc.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        vc.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        vc.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        vc.didMove(toParent: self)
    }

    func removeAllChildViewControllers() {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
}
