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
struct StickerManager {
    let token = SnapAuthKeys.SnapKitAPIToken_Staging

    func testit(searchTerm: String, numResults: Int = 3) {

        var semaphore = DispatchSemaphore (value: 0)

        /// yes this is messy but attempting to use raw strings and multi-line raw strings got a JSON error don't have time to debug.
        let parameters = "{\"query\":\"query SearchStickerSample {\\r\\n  sticker {\\r\\n    searchStickers(\\r\\n      req:{\\r\\n        searchStickersParams:{searchText: \\\"\(searchTerm)\\\", numberResults: \(numResults)},\\r\\n        stickerUserContext:{countryCode: US, localTimeZoneUTCOffsetMinutes: 2,locale: EN_US}\\r\\n      }){\\r\\n      stickerResults {\\r\\n        items {\\r\\n          itemType\\r\\n          id\\r\\n          pngURL\\r\\n          thumbnailURL\\r\\n        }\\r\\n      }\\r\\n    }\\r\\n  }\\r\\n}\",\"variables\":{}}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://graph.snapchat.com/graphql")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

    }
    
}
