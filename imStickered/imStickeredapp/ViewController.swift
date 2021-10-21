//
//  ViewController.swift
//  imStickeredapp
//
//  Created by Andrew Dent on 18/6/20.
//  Copyright © 2020 Touchgram Pty Ltd. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    static var urlToShowFromMessage:URL? = nil
    let mgr = StickerManager()
    
    @IBOutlet weak var results: UITextView!
    @IBOutlet weak var searchEntry: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup the webview and load any incoming
    }
    
    @IBAction func onTest(_ sender: Any) {
        guard let searchFor = searchEntry.text, !searchFor.isEmpty else {return}
        mgr.testit(searchTerm: searchFor)
    }

}

