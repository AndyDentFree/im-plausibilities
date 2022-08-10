//
//  MessagesViewController.swift
//  webFromIM MessagesExtension
//
//  Created by Andrew Dent on 12/1/19.
//  Copyright © 2019 Touchgram Pty Ltd. All rights reserved.
//

import UIKit
import os
import Messages
import WebKit

class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet fileprivate weak var openInSafari: UIButton!
    @IBOutlet weak var openInApp: UIButton!
    @IBOutlet weak var openHere: UIButton!
    
    @IBOutlet fileprivate weak var statusLabel: UILabel!
    @IBOutlet weak var urlEntry: UITextField!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var controlsStack: UIStackView!
    
    var isShowingLocalURL = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func toggleButtons(starting:Bool) {
    }
    
    // MARK: - Conversation Handling
    func hasIncoming(message: MSMessage) {
        // Use this method to trigger UI updates in response to the message.
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
            toggleButtons(starting: true)
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
        // this extension is active (ie: composing a new message with it)
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
        if isShowingLocalURL {
            if presentationStyle == .expanded {
                showWebLocally()
            } else {  // presume collapsed
                isShowingLocalURL = false
                toggleWeb(on: false)
            }
        } else {
            urlEntry.isEnabled = presentationStyle == .expanded
        }

    }
    
   // MARK: - Helpers
    private func openWeb(inApp: Bool) {
        // this guard is doubly-protected by onEditingChanged
        guard let urlStr = urlEntry?.text,
            let url = URL(string:urlStr) else {
                statusLabel.text = "Bad URL"
                return
        }
        
        let handler = { (success:Bool) -> () in
            if success {
                os_log("Finished opening URL")
            } else {
                os_log("Failed to open URL")
            }
        }

        let encodedUrl = url.dataRepresentation.base64EncodedString()
        let inAppFlag = inApp ? "&openInApp=true" : ""
        let appUrlStr = "webFromIM://?url=\(encodedUrl)\(inAppFlag)"
        guard let appUrl: URL = URL(string: appUrlStr) else {
            os_log("Unable to launch app URL")
            return
        }
        // can only open our app, not generalised URLs
        self.extensionContext?.open(appUrl, completionHandler: handler)
    }
    
    private func toggleWeb(on webVisible:Bool) {
        webView.isHidden = !webVisible
        controlsStack.isHidden = webVisible
    }
    
    private func showWebLocally() {
        guard let urlStr = urlEntry?.text,
            let url = URL(string:urlStr) else {
                statusLabel.text = "Bad URL"
                return
        }
        toggleWeb(on: true)
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }
    
    // MARK: - Buttons
    @IBAction func onEditingChanged(_ sender: UITextField) {
        let canGo = (urlEntry?.text != nil) && URL(string:urlEntry!.text!) != nil
        openHere.isEnabled = canGo
        openInApp.isEnabled = canGo
        openInSafari.isEnabled = canGo
    }
    
    @IBAction public func onOpenWeb(_ sender: UIButton)  {
        openWeb(inApp:false)
    }
    
    @IBAction func onOpenInApp(_ sender: UIButton) {
        openWeb(inApp:true)
    }
    
    @IBAction func onOpenHere(_ sender: UIButton) {
        isShowingLocalURL = true
        // request a transition
        if presentationStyle == .expanded {
            showWebLocally()
        } else {
            requestPresentationStyle(.expanded)
        }
    }
    
}