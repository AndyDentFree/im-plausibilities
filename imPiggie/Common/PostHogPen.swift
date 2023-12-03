//
//  PostHogPen.swift
//  imPiggie
//
//  Created by AndyDent on 3/12/2023.
//  Copyright © 2023 Touchgram Pty Ltd. All rights reserved.
//

import Foundation
import PostHog

struct PostHogPen {
    static var trough: PHGPostHog? = nil
    
    static func setup() {
        // from https://posthog.com/docs/libraries/ios but refined for privacy
        // relies on a simple struct that is NOT COMMITTED TO GITHUB

        let configuration = PHGPostHogConfiguration(apiKey: imPiggieSecrets.PostHog_apiKey) // `host` is optional if you use app.posthog.com

        configuration.captureApplicationLifecycleEvents = false
        configuration.recordScreenViews = false

        PHGPostHog.setup(with: configuration)
        trough = PHGPostHog.shared()
    }
}
