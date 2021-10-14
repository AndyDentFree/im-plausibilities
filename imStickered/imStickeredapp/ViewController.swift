//
//  ViewController.swift
//  imStickeredapp
//
//  Created by Andrew Dent on 18/6/20.
//  Copyright © 2020 Touchgram Pty Ltd. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {

    static var urlToShowFromMessage:URL? = nil
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup the webview and load any incoming
        webView.uiDelegate = self
        // bit of a hack to ensure the app delegate can force a refresh of us
        AppDelegate.urlDisplayer = { self.showURL() }
        showURL()
    }
    
    private func showURL() {
        if ViewController.urlToShowFromMessage != nil {
            let myURL = ViewController.urlToShowFromMessage
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        } else {
            webView.loadHTMLString("<html><body><h1>no URL specified, launch from iMessage</h1></body></html>", baseURL: nil)
        }
    }

}

