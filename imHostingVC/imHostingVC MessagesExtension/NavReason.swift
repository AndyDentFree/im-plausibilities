//
// Created by Andrew Dent on 2019-02-27.
// Copyright (c) 2019 Touchgram Pty Ltd. All rights reserved.
//

import Foundation

// low numbers are used in EditingContext as persisted raw values
// higher values not expected to persist but keeping one enum rather than parallel types
// enum raw values here aligned with tgCreationType
public enum NavReason : Int {
    case food
    case mood
    case menu

    func needsToBeExpanded() -> Bool {
        return self == .food
    }
}
