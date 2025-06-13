//
//  MessageComposerInApp.swift
//  imUrlDataApp
//
//  Created by AndyDent on 5/8/2022.
//  Copyright © 2022 Touchgram Pty Ltd. All rights reserved.
//

import Foundation
import MessageUI
import Messages

class MessageComposingHelper: NSObject, MFMessageComposeViewControllerDelegate {

    func canSendText() -> Bool {
        MFMessageComposeViewController.canSendText()
    }
    
    func displayMessageInterface(onVC vc: UIViewController, mood:Mood, withCustomMessage: Bool = true, withImageInBubble: Bool = false) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.disableUserAttachments()  // has no visible effect, are already disabled
        
        // Configure the fields of the interface.
        // claim that setting this stops attachments composeVC.recipients = ["123456"]
        if withCustomMessage {
            let layout = MSMessageTemplateLayout()
            layout.caption = "Sample message"
            if withImageInBubble {
                layout.image = mood.image(of: CGSize(width: 200, height: 200))
            }
            //
            /*
             According to
             https://developer.apple.com/documentation/messageui/mfmessagecomposeviewcontroller/2213331-message
             If your app has an iMessage app extension, you can display your iMessage app within the message compose view, just as you would in the Messages app. To display your iMessage app, create and assign an MSMessage object to this property.

             By default, this property is set to nil.
             */
            if #available(iOS 10, *) {  // necessary if clause to make XCode happy to use composeVC.message
                let message = MSMessage(session: MSSession())
                // fake building a smiley using hardcoded stuff to match MessagesViewController.send
                guard var urlComps = URLComponents(string:"data:,") else {
                    fatalError("Invalid base URL")
                }
                urlComps.queryItems = [URLQueryItem(name: Mood.moodKey, value:mood.rawValue)]
                message.url = urlComps.url
                message.layout = layout
                composeVC.body = "Sending a custom message"
                composeVC.message = message
            }
        } else {
            if MFMessageComposeViewController.canSendAttachments() {
                print("Attachments should be available")
            } else {
                print("Can't send messages.")
            }
        }
        
        // Present the view controller modally. It is designed as a pageSheet because of security constraints
        if MFMessageComposeViewController.canSendText() {
            vc.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }

    //MARK - conform to MFMessageComposeViewControllerDelegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        let msgStr = result == .cancelled ?
            "Cancelled" : result == .failed ?
            "Failed" :
            "Sent"
        print(msgStr)
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
