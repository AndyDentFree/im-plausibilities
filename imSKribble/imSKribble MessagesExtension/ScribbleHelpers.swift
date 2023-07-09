//
// Created by Andrew Dent on 25/5/18.
// Copyright (c) 2018 Touchgram Pty Ltd. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint {
    func notCloseTo(_ rhs:CGPoint) -> Bool {
        let epsilon : CGFloat = 2.0
        return abs(x - rhs.x) > epsilon || abs(y - rhs.y) > epsilon
    }
}

//MARK:- enc/decoding helpers
extension MessagesViewController {
    
    func data(from points: [CGPoint]) -> Data? {
        let convertedPoints = points.flatMap { [$0.x, $0.y] }.map { UInt32(max($0, 0.0)) }
        guard convertedPoints.count > 0 else {return nil}
        return convertedPoints.withUnsafeBytes { Data($0) }
    }
    
    func points(from data: Data) -> [CGPoint] {
        let uint32Data = data.withUnsafeBytes { $0.bindMemory(to: UInt32.self) }
        var points = [CGPoint]()
        for i in stride(from: 0, to: uint32Data.count, by: 2) {
            let x = CGFloat(uint32Data[i])
            let y = CGFloat(uint32Data[i + 1])
            points.append(CGPoint(x: x, y: y))
        }
        return points
    }
}
