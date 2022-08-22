//
//  Mood.swift
//  imUrlDataApp
//
//  Created by AndyDent on 6/8/2022.
//  Copyright © 2022 Touchgram Pty Ltd. All rights reserved.
//

import Foundation

// matches emoji used as button labels to cases
enum Food : String, CaseIterable, UrlSendable {
    
    case burger = "🍔"
    case hotdog = "🌭"
    case taco = "🌮"
    case chips = "🍟"
    case burrito = "🌯"
    
    static let foodKey = "food"
  
    static subscript(i: Int) -> Mood? {
        guard i >= 0 && i < 4 else {return nil}
        return Mood.allCases[i]
    }
    
    //UrlSendable
    func key() -> String {
        Mood.moodKey
    }
    
    func value() -> String {
        self.rawValue
    }

}
