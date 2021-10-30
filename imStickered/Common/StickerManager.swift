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
  
  //MARK downloading
  
  func download(url: URL, toFile file: URL, completion: @escaping (Error?) -> Void) {
      // Download the remote URL to a file
      let task = URLSession.shared.downloadTask(with: url) {
          (tempURL, response, error) in
          // Early exit on error
          guard let tempURL = tempURL else {
              completion(error)
              return
          }

          do {
              // Remove any existing document at file
              if FileManager.default.fileExists(atPath: file.path) {
                  try FileManager.default.removeItem(at: file)
              }

              // Copy the tempURL to file
              try FileManager.default.copyItem(
                  at: tempURL,
                  to: file
              )

              completion(nil)
          }

          // Handle potential file system errors
          catch let fileError {
              completion(fileError)
          }
      }

      // Start the download
      task.resume()
  }
  /// Note that files are just dumped in the temp area where will be wiped as phone runs tight on space
  func loadData(url: URL, completion: @escaping (Data?, Error?) -> Void) -> Data? {
      // Compute a path to the URL in the cache
      let fileCachePath = FileManager.default.temporaryDirectory
          .appendingPathComponent(
              url.lastPathComponent,
              isDirectory: false
          )
      
      // If the image exists in the cache,
      // load the image from the cache and exit
      if let data = try? Data(contentsOf: fileCachePath) {
          // don't invoke as that's probably an async completer completion(data, nil)
          // and we are likely invoked by something that is already on main thread, populating a view
          print("got file \(fileCachePath)")
          return data
      }
      
    print("downloading \(url) to \(fileCachePath)")

      // If the image does not exist in the cache,
      // download the image to the cache
      download(url: url, toFile: fileCachePath) { (error) in
          let data = try? Data(contentsOf: fileCachePath)
          completion(data, error)
      }
    return nil
  }
  
  /// return immediate Data from cached file or trigger asynch download
  func image(at ip: IndexPath, asThumb: Bool = true, completion: @escaping (Data?, Error?) -> Void) -> Data? {
    guard ip.row < stickers.count else {return nil}
    let imgURL = asThumb ? stickers[ip.row].thumbnailURL : stickers[ip.row].pngURL
    guard let url = URL(string: imgURL) else {return nil}
    return loadData(url: url, completion: completion)
  }
}
