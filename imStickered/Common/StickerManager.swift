//
//  StickerManager.swift
//  imStickered
//
//  Created by AndyDent on 21/10/21.
//  Copyright © 2021 Touchgram Pty Ltd. All rights reserved.
//


/*
see https://www.advancedswift.com/http-requests-in-swift/
*/


import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
class StickerManager {
    let token = SnapAuthKeys.SnapKitAPIToken_Staging
    // pull the array from the nested parsing struct
    var stickers = [StickerDescriptor]()
    var searchCount: Int {stickers.count}
    var lastSearchTerm: String = ""

    func search(for searchTerm: String, wantingMaxItems numResults: Int = 3,  logger: @escaping (String)->()) {
        
        var semaphore = DispatchSemaphore (value: 0)
        lastSearchTerm = searchTerm

        /// yes this is messy but attempting to use raw strings and multi-line raw strings got a JSON error don't have time to debug.
        let parameters = "{\"query\":\"query SearchStickerSample {\\r\\n  sticker {\\r\\n    searchStickers(\\r\\n      req:{\\r\\n        searchStickersParams:{searchText: \\\"\(searchTerm)\\\", numberResults: \(numResults)},\\r\\n        stickerUserContext:{countryCode: US, localTimeZoneUTCOffsetMinutes: 2,locale: EN_US}\\r\\n      }){\\r\\n      stickerResults {\\r\\n        items {\\r\\n          itemType\\r\\n          id\\r\\n          pngURL\\r\\n          thumbnailURL\\r\\n        }\\r\\n      }\\r\\n    }\\r\\n  }\\r\\n}\",\"variables\":{}}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://graph.snapchat.com/graphql")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
          guard let data = data else {
            let msg = String(describing: error)
            print(msg)
            logger(msg)
            semaphore.signal()
            return
          }
          let msg = String(data: data, encoding: .utf8)!
          self?.parseStickerSearch(from: data)
          //print(msg)
          logger(msg)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

    }
    
  func parseStickerSearch(from json: Data) {
    let decoder = JSONDecoder()
    guard let jsonStickers = try? decoder.decode(StickerResults.self, from: json) else {return}
    stickers = jsonStickers.data.sticker.searchStickers.stickerResults.items
    print(stickers.count == 0 ? "No stickers for '\(lastSearchTerm)'" : stickers[0])
  }
    
}
