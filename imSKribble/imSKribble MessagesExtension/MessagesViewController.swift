//
//  MessagesViewController.swift
//  imSKribble MessagesExtension
//
//  Created by Andrew Dent on 12/1/19.
//  Copyright © 2019 Touchgram Pty Ltd. All rights reserved.
//

import UIKit
import os
import Messages
import SpriteKit

class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var skView: SKView!
    
    var receivedTouches = [CGPoint]()
    let pointsKey = "points"
    var scene: ScribbleGameScene? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        makeScene()

        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    
    // MARK: - Conversation Handling
    func hasIncoming(message: MSMessage) {
        // Use this method to trigger UI updates in response to the message.
        guard let url = message.url else { return }
        guard let comps = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        if let pointsString = comps.queryItems?.first(where: { $0.name == pointsKey })?.value,
           let pointsData = Data(base64Encoded: pointsString) {
            receivedTouches = points(from: pointsData)
            scene?.draw(&receivedTouches, asLocal: false)
        }
    }
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        // NOTE that means you may have launched the extension to compose a new message OR selected previous, which also hits didSelect
        
        // Use this method to configure the extension and restore previously stored state.
    }

    override func didBecomeActive(with conversation: MSConversation) {
        guard let sel = conversation.selectedMessage else {
            os_log("didBecomeActive with no selectedMessage in conversation")
            return
        }
        print("didBecomeActive \(sel.debugDescription)\n URL \(sel.url?.absoluteString ?? "no URL")")
        hasIncoming(message: sel)
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }

    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        os_log("didSelect")
        print("didSelect \(message.debugDescription)\n URL \(message.url?.absoluteString ?? "no URL")")
        super.didSelect(message, conversation: conversation)
        hasIncoming(message: message)
    }

    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device. ONLY if the message arrives whilst
        // this extension is active (see commented-out dismiss below)
        hasIncoming(message: message)
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
       
    func send(points: [CGPoint]) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        guard var urlComps = URLComponents(string:"data:,") else {
            fatalError("Invalid base URL")
        }
        guard let pointsData = data(from: points) else {return}
        let encPoints = pointsData.base64EncodedString()
        let qi = [
            URLQueryItem(name: pointsKey, value: encPoints)
        ]
        urlComps.queryItems = qi
        let layout = MSMessageTemplateLayout()
        let session = conversation.selectedMessage?.session
        let message = MSMessage(session: session ?? MSSession())
        message.layout = layout
        if let toSend = urlComps.url {
            message.url = toSend
            print("send attempted with URL \(toSend.absoluteString)\n")
            // immediate send vs insert which gives user time to edit the message bubble and add text
            conversation.send(message) { (error) in
                if let error = error {
                    os_log("Error with MSConversation.insert(message)")
                    print(error)
                }
            }
        }
        // dismiss() leave the session running so we can respond without starting a new message
    }

    func makeScene() {
        scene = ScribbleGameScene.newGameScene()
        skView.presentScene(scene)
    }


    // MARK: - Buttons

    @IBAction func onClear(_ sender: Any) {
        receivedTouches.removeAll(keepingCapacity: true)
        scene?._pointsDrawn.removeAll(keepingCapacity: true)
        makeScene()
    }
    
    @IBAction func onSend(_ sender: Any) {
        guard let sendablePoints = scene?._pointsDrawn else {return}
        send(points: sendablePoints)
    }
}