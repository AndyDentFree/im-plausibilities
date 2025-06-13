//
//  MoodRenderers.swift
//  imUrlDataApp
//
//  Created by Andrew Dent on 13/6/2025.
//  Copyright © 2025 Touchgram Pty Ltd. All rights reserved.
//

import UIKit

extension Mood {
    /// 1. A single‐emoji string for each mood
    var emoji: String {
        switch self {
        case .happy:      return "😊"
        case .quizzical:  return "🤔"
        case .distraught: return "😩"
        case .angry:      return "😡"
        }
    }

    /// 2. Render this mood’s emoji into a `UIImage` of a given size
    func image(of size: CGSize, fontScale: CGFloat = 0.8) -> UIImage {
        // Use UIGraphicsImageRenderer to draw text into a bitmap
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            // Choose a font size that fills most of the image
            let fontSize = min(size.width, size.height) * fontScale
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize),
                .paragraphStyle: {
                    let p = NSMutableParagraphStyle()
                    p.alignment = .center
                    return p
                }()
            ]

            // Measure the emoji
            let attrString = NSAttributedString(string: self.emoji, attributes: attributes)
            let textSize = attrString.size()

            // Center it
            let drawRect = CGRect(
                x: (size.width  - textSize.width)  / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )

            // Draw into the context
            attrString.draw(in: drawRect)
        }
    }
}
