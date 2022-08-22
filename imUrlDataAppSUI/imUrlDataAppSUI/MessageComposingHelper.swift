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

/// helper class originally used to provide a static method to let you send the message from teh app
class MessageComposingHelper: NSObject {

    func canSendText() -> Bool {
        MFMessageComposeViewController.canSendText()
    }
    /*
    func displayMessageInterface(onVC vc: UIViewController, mood:Mood) {
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            vc.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
*/
    //MARK - conform to MFMessageComposeViewControllerDelegate
}
