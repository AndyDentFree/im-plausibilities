//
//  MessageComposerInApp.swift
//  imPiggie
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
    
    func displayMessageInterface(onVC vc: UIViewController, mood:Mood) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = ["123456"]
        composeVC.body = "Sending a custom message"
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
            composeVC.message = message
        }
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            PostHogPen.trough?.capture("composing", properties: ["mood": mood.rawValue])
            vc.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
            PostHogPen.trough?.capture("message composer unable to present")
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
        PostHogPen.trough?.capture("sent", properties: ["status": msgStr])
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
