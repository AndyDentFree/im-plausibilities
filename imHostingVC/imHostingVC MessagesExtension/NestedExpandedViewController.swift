//
//  NestedExpandedViewController.swift
//  imHostingVC MessagesExtension
//
//  Created by Andrew Dent on 11/8/2022.
//  Copyright © 2022 Touchgram Pty Ltd. All rights reserved.
//

import UIKit

class NestedExpandedViewController: UIViewController, NavCommandTarget {

    /// undo our hosting
    @IBAction func onBack(_ sender: Any) {
        MessagesViewController.current().navigateBack()
    }

    /// handle any emoji button
    @IBAction func onPick(_ sender: UIButton) {
        guard let toSend = Food(rawValue: sender.titleLabel?.text ?? "") else {return}
        MessagesViewController.currentMessagesVC?.send(what: toSend)
    }
}
