//
//  UrlSendable.swift
//  imHostingVC MessagesExtension
//
//  Created by Andrew Dent on 12/8/2022.
//  Copyright © 2022 Touchgram Pty Ltd. All rights reserved.
//

import Foundation
import Metal

/// items which may be sent in the iMessage URL field
protocol UrlSendable {
    func key() -> String
    func value() -> String
}
