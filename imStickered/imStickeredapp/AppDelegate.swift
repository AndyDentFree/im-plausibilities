//
//  AppDelegate.swift
//  imStickeredapp
//
//  Created by Andrew Dent on 18/6/20.
//  Copyright © 2020 Touchgram Pty Ltd. All rights reserved.
//

import UIKit
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var urlDisplayer:(()->Void)? = nil  // allow the ViewController to set us up if it's already launched

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        let comps = URLComponents(url: url, resolvingAgainstBaseURL: false)
        guard let encodedUrl = comps?.queryItems?.first(where: {$0.name == "url"})?.value,
            let wrappedUrl = Data(base64Encoded: encodedUrl),
            let urlToOpen = URL(dataRepresentation: wrappedUrl, relativeTo: nil) else {
                os_log("Unable to parse URL, %s", url.absoluteString)
                return false
        }
        
        if (comps?.queryItems?.first(where: {$0.name == "openInApp"})?.value) != nil {
            os_log("About to launch URL locally, %s", urlToOpen.absoluteString)
            ViewController.urlToShowFromMessage = urlToOpen
            if AppDelegate.urlDisplayer != nil {
               AppDelegate.urlDisplayer!()
            }
            return true
        }
        os_log("About to launch URL, %s", urlToOpen.absoluteString)
        UIApplication.shared.open(urlToOpen)
        return true  // we are presumably now going off to Safari but could actually launch a local app if they sent the right URL
    }

}

