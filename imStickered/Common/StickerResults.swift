//
//  StickerResults.swift
//  imStickered
//
//  Created by AndyDent on 22/10/21.
//  Copyright © 2021 Touchgram Pty Ltd. All rights reserved.
//

import Foundation

/*
 Data like
 {"data":{"sticker":{"searchStickers":{"stickerResults":{"items":[{"itemType":"SNAPCHAT_STICKERS","id":"Ac6oHlYLllej","pngURL":"https://bolt-gcdn.sc-cdn.net/3/xLwPNHGGnnUz9J4gNa0J6?bo=EiIaABoAMgF9OgsEBQcNDxFydHZ3e0IGCLDgy-8FSAJQB2AB\u0026uc=7\u0026appID=099854d8-a4f9-4c04-ba71-0f3c20e31ad4\u0026sessionID=b7aeb8a9-b098-4b6f-b6f9-90325328ebf3","thumbnailURL":"https://bolt-gcdn.sc-cdn.net/3/xLwPNHGGnnUz9J4gNa0J6?bo=EiIaABoAMgF9OgsEBQcNDxFydHZ3e0IGCLDgy-8FSAJQB2AB\u0026uc=7\u0026appID=099854d8-a4f9-4c04-ba71-0f3c20e31ad4\u0026sessionID=b7aeb8a9-b098-4b6f-b6f9-90325328ebf3"}
 */

/// using Codable not to persist but to parse incoming JSON
/// hacky, simpler way to handle nested data with nested definitions - look up using CodingKeys as cleaner but more complex code
struct StickerResults: Decodable {
  struct NestedData: Decodable {
    struct NestedSticker: Decodable {
      struct NestedSearchStickers: Decodable {
        struct NestedResults: Decodable {
          let items: [StickerDescriptor]
        }
        let stickerResults: NestedResults
      }
      let searchStickers: NestedSearchStickers
    }
    let sticker: NestedSticker
  }
  let data: NestedData
}
