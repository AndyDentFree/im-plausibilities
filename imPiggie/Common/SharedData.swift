//
//  SharedData.swift
//  imPiggie
//
//  Created by Andrew Dent on 18/1/19.
//  Copyright © 2019 Touchgram Pty Ltd. All rights reserved.
//

// in a more complex app this would be in a shared framework but is just one file compiled in both targets
import Foundation

public enum controlIndexes:Int, CaseIterable {
    case happy=0
    case quizzical=1
    case distraught=2
    case angry=3
}


class SharedData {
    /*let docsBaseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!*/
    let docsBaseURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.touchgram.imPiggie")!
    lazy var plistURL = docsBaseURL.appendingPathComponent("sharedDetails.plist")
    let enabledKey = "Enabled"
    
    static var current = SharedData()

    func loadEnabled() -> [Bool] {
        if FileManager.default.fileExists(atPath:plistURL.path) {
            if let dict = NSDictionary(contentsOf:plistURL) as? [String:AnyObject] {
                if let readEn = dict[enabledKey] as? [Bool] {
                    assert(readEn.count == controlIndexes.allCases.count)
                    return readEn
                }
            }
        }
        return Array(repeating: true, count: controlIndexes.allCases.count)
    }

    func save(enabled:[Bool]) {
        let dict = NSDictionary(dictionary: [enabledKey:enabled])
        dict.write(to: plistURL, atomically:true)
    }
}
