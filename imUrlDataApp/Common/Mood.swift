//
//  Mood.swift
//  imUrlDataApp
//
//  Created by AndyDent on 6/8/2022.
//  Copyright © 2022 Touchgram Pty Ltd. All rights reserved.
//

import Foundation

enum Mood : String, CaseIterable {
    case happy
    case quizzical
    case distraught
    case angry
    
    static let moodKey = "mood"
  
    static subscript(i: Int) -> Mood? {
        guard i >= 0 && i < 4 else {return nil}
        return Mood.allCases[i]
    }

}
