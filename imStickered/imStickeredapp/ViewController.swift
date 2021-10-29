//
//  ViewController.swift
//  imStickeredapp
//
//  Created by Andrew Dent on 18/6/20.
//  Copyright © 2020 Touchgram Pty Ltd. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    static var urlToShowFromMessage:URL? = nil
    let mgr = StickerManager()
    
    @IBOutlet weak var results: UITextView!
    @IBOutlet weak var searchEntry: UITextField!
    @IBOutlet weak var thumbnailsView: UICollectionView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    // helper for callback from downloading, to dump the string returned
    func updateResults(_ msg: String) {
        DispatchQueue.main.async {
            self.results.text = msg
            //TODO be smarter - show spinner until have all thumbnails
            self.loadingSpinner.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thumbnailsView.delegate = self
        thumbnailsView.dataSource = self
    }
    
    @IBAction func onSearch(_ sender: Any) {
        guard let searchFor = searchEntry.text, !searchFor.isEmpty else {return}
        //TODO have way to enter wantingMaxItems
        loadingSpinner.isHidden = false
        loadingSpinner.startAnimating()
        mgr.search(for: searchFor, wantingMaxItems: 20, logger: {self.updateResults($0)})
    }

    //MARK as UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      mgr.searchCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbCell", for: indexPath) as! ThumbCell
      //TODO get the image from the thumbnail
        return cell
    }
    


}

