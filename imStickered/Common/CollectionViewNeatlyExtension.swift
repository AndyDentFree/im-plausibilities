//
//  CollectionViewNeatlyExtension.swift
//  imStickered
//
//  Created by AndyDent on 31/10/21.
//  Copyright © 2021 Touchgram Pty Ltd. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewNeatlyExtension where Self: UIViewController {
  var spaceBetween: UIEdgeInsets {get}  // allow instantiators to easily specify insets
  var fixedItemsPerRow: CGFloat {get}
  func standardItemWidth(_ collectionView: UICollectionView) -> CGSize
}

extension CollectionViewNeatlyExtension {
  func standardItemWidth(_ collectionView: UICollectionView) -> CGSize {
    let availableWidth = view.frame.width - spaceBetween.left * (fixedItemsPerRow + 1)
    let widthPerItem = availableWidth / fixedItemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }

}
