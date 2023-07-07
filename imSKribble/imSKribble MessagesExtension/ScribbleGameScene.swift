//
//  GameScene2LineNodes.swift
//  copied from ShapeScribble Shared
//
//  Created by Andy Dent on 23/5/18.
//  Copyright © 2018 Touchgram Pty Ltd. All rights reserved.
//

import SpriteKit

class ScribbleGameScene: SKScene {

    var _pointsDrawn = [CGPoint]()
    var _tempNodes = [SKShapeNode]()
    var _localColor = SKColor.yellow
    var _remoteColor = SKColor.red

    class func newGameScene(gameSize: CGSize = CGSize(width: 1366, height: 1024)) -> ScribbleGameScene {
        return ScribbleGameScene(size: gameSize, setAspectFill: true)
    }

    convenience init (size:CGSize, setAspectFill: Bool) {
        self.init(size:size)
        scaleMode = .aspectFill
    }
    
    func touchDown(atPoint pos: CGPoint) {
        _pointsDrawn = [pos]
    }

    func touchMoved(toPoint pos: CGPoint) {
        guard pos.notCloseTo(_pointsDrawn.last!) else {
            return
        }
        updatePath(pos)
    }

    // points is inout because UnsafeMutablePointer used to create SKShapeNode, not because they are changed
    func draw(_ points: inout [CGPoint], asLocal: Bool = true) {
        let finishedPts = SKShapeNode(splinePoints: &points, count: points.count)
        finishedPts.lineWidth = 1
        finishedPts.strokeColor = asLocal ? _localColor : _remoteColor
        finishedPts.glowWidth = 4.0
        addChild(finishedPts)
    }
    
    func touchUp(atPoint pos: CGPoint) {
        if !pos.notCloseTo(_pointsDrawn.last!) {
            _pointsDrawn.append(pos)
        }
        removeChildren(in: _tempNodes)  // neaten things up - this has no perceivable performance impact
        draw(&_pointsDrawn)
    }

    func updatePath(_ pos: CGPoint) {
        _pointsDrawn.append(pos)
        // add new node of two points
        let linesNode = SKShapeNode(points: &_pointsDrawn[_pointsDrawn.count - 2], count: 2)
        linesNode.lineWidth = 1
        linesNode.strokeColor = _localColor
        addChild(linesNode)
        _tempNodes.append(linesNode)  // WHOA! this makes a playground slow down massively
    }

#if os(watchOS)
    override func sceneDidLoad() {
    }
#else
    override func didMove(to view: SKView) {
    }
#endif

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension ScribbleGameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchMoved(toPoint: t.location(in: self))
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchUp(atPoint: t.location(in: self))
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }


}
#endif

#if os(OSX)
// Mouse-based event handling
extension ScribbleGameScene {

    override func mouseDown(with event: NSEvent) {
        touchDown(atPoint: event.location(in: self))
    }

    override func mouseDragged(with event: NSEvent) {
        touchMoved(toPoint: event.location(in: self))
    }

    override func mouseUp(with event: NSEvent) {
        touchUp(atPoint: event.location(in: self))
    }

}
#endif

