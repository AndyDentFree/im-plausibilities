//
//  ViewController.swift
//  imStickeredapp
//
//  Created by Andrew Dent on 18/6/20.
//  Copyright © 2020 Touchgram Pty Ltd. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UICollectionViewDelegate, CollectionViewNeatlyExtension {
    static var urlToShowFromMessage:URL? = nil
    let mgr = StickerManager()
    //CollectionViewNeatlyExtension
    var spaceBetween: UIEdgeInsets = UIEdgeInsets(top: 20.0, left: 12.0, bottom: 20.0, right: 12.0)
    var fixedItemsPerRow: CGFloat = 1.0
    var transcriptHidden = false
    var originalResultsHeight: CGFloat = 0.0

    @IBOutlet weak var results: UITextView!
    @IBOutlet weak var searchEntry: UITextField!
    @IBOutlet weak var thumbnailsView: UICollectionView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var transcriptHider: UIButton!
    @IBOutlet weak var resultsHeight: NSLayoutConstraint!
    
    // helper for callback from downloading, to dump the string returned
    func updateResults(_ msg: String) {
        DispatchQueue.main.async {
          self.results.text = msg
          //TODO be smarter - show spinner until have all thumbnails
          self.loadingSpinner.stopAnimating()
            self.transcriptHider.isHidden = false  // hide until have search complete
          self.thumbnailsView.reloadData()  // will trigger pulls of thumbnail images
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fixedItemsPerRow = thumbnailsView.frame.width > 300 ? 4 : 3
        thumbnailsView.delegate = self
        thumbnailsView.dataSource = self
        originalResultsHeight = resultsHeight.constant  //  stashed for toggling
    }
    
    @IBAction func onSearch(_ sender: Any) {
        guard let searchFor = searchEntry.text, !searchFor.isEmpty else {return}
        //TODO have way to enter wantingMaxItems
        loadingSpinner.isHidden = false
        transcriptHider.isHidden = true
        loadingSpinner.startAnimating()
        mgr.search(for: searchFor, wantingMaxItems: 20, logger: {self.updateResults($0)})
    }
    
    @IBAction func onHideTranscript(_ sender: Any) {
        transcriptHidden = !transcriptHidden
        let newT = (transcriptHidden ? "Show" : "Hide") + " Search Transcript"
        transcriptHider.setTitle(newT, for: .normal)
        resultsHeight.constant = transcriptHidden ? 0.0 : originalResultsHeight
    }
}


//MARK as UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  mgr.searchCount
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbCell", for: indexPath) as! ThumbCell
  //TODO handle failure to the image from the thumbnail
  let title = mgr.stickers[indexPath.row].id
  print("thumbnail ID for cell \(indexPath.row) is '\(title)'")
  cell.thumbName.text = title  // normally wouldn't display this as not readable title
  if let imgDataFromCache = mgr.image(at: indexPath, completion: {(imgData: Data?, downloadErr: Error?) in
    if let imgDataDownloaded = imgData {
      DispatchQueue.main.async {
        cell.thumbImage.image = UIImage(data: imgDataDownloaded)
      }
    }
  }) {
    cell.thumbImage.image = UIImage(data: imgDataFromCache)
  }
  return cell
}}


// MARK: - Collection View Flow Layout Delegate - using CollectionViewNeatlyExtension
extension ViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      standardItemWidth(collectionView)
  }
    
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    spaceBetween
  }
    
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    spaceBetween.top
  }
}
