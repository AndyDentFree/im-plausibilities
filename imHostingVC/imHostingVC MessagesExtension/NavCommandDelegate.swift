//
//  NavCommandDelegate.swift
//  imHostingVC MessagesExtension
//
//  Created by Andrew Dent on 12/8/2022.
//  Copyright © 2022 Touchgram Pty Ltd. All rights reserved.
//

import Foundation
import UIKit
import Messages

protocol NavCommandDelegate {
    func navigate(because:NavReason)
    func navigateBack()
    func makeVC(with presentationStyle: MSMessagesAppPresentationStyle) -> UIViewController
    static func current() -> NavCommandDelegate
}

protocol NavCommandTarget {
    // used to label View Controllers we expect to navigate to from MesszagesTopNavigation
}