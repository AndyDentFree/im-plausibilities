//
//  MessagesCompensatingSKView.swift
//  imSKribble MessagesExtension
//
//  Created by Andrew Dent on 9/7/2023.
//  Copyright © 2023 Touchgram Pty Ltd. All rights reserved.
//

import UIKit
import SpriteKit

// fix for iOS17 change to how Messages expands app extension container space - by default allows pan as well as dragging or tapping top edge
class MessagesCompensatingSKView: SKView {

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !(gestureRecognizer is UIPanGestureRecognizer)
    }

}
