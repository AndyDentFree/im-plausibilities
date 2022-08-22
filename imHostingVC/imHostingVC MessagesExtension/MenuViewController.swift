//
//  MenuViewController.swift
//  imHostingVC MessagesExtension
//
//  Created by Andrew Dent on 14/8/2022.
//  Copyright © 2022 Touchgram Pty Ltd. All rights reserved.
//

import UIKit

/// used as first hosted controller
class MenuViewController: UIViewController, NavCommandTarget {
    
    @IBOutlet fileprivate weak var statusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    // MARK: - Navigation Buttons
    // trigger navigation which may expand area

    @IBAction public func onMoods(_ sender: UIButton)  {
        MessagesViewController.current().navigate(because: .mood)
    }

    @IBAction public func onFoods(_ sender: UIButton)  {
        MessagesViewController.current().navigate(because: .food)
    }


}
