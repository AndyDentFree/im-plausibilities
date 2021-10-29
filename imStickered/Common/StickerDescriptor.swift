//
//  StickerDescriptor.swift
//  imStickered
//
//  Created by AndyDent on 22/10/21.
//  Copyright © 2021 Touchgram Pty Ltd. All rights reserved.
//

import Foundation

/// using Codable not to persist but to parse incoming JSON
struct StickerDescriptor: Decodable {
    let id: String
    let pngURL: String
    let thumbnailURL: String
}
