//
//  ViewController.swift
//  imUrlDataApp
//
//  Created by Andrew Dent on 17/1/19.
//  Copyright © 2019 Touchgram Pty Ltd. All rights reserved.
//

import UIKit
import MessageUI
import Messages

extension UISwitch {
    func toggle() {
        self.setOn(!self.isOn, animated: true)
    }
}

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet fileprivate weak var happyBtn: UIButton!
    @IBOutlet fileprivate weak var quizzicalBtn: UIButton!
    @IBOutlet fileprivate weak var distraughtBtn: UIButton!
    @IBOutlet fileprivate weak var angryBtn: UIButton!
    @IBOutlet fileprivate weak var happySwitch: UISwitch!
    @IBOutlet fileprivate weak var quizzicalSwitch: UISwitch!
    @IBOutlet fileprivate weak var distraughtSwitch: UISwitch!
    @IBOutlet fileprivate weak var angrySwitch: UISwitch!
    @IBOutlet fileprivate weak var appSendButton: UIButton!
    
    lazy var toggles = [happySwitch, quizzicalSwitch, distraughtSwitch, angrySwitch]
    lazy var buttons = [happyBtn, quizzicalBtn, distraughtBtn, angryBtn]
    var lastToggled : controlIndexes? = nil

    // array of flags instead of storing state in the switch so can easily save and load
    var enabled = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        enabled = SharedData.current.loadEnabled()
        // initial loading loop - if read at least one false
        if enabled.contains(false) {
            for (i, isOn) in enabled.enumerated() {
                buttons[i]?.alpha = isOn ? 1.0 : 0.3
                toggles[i]?.isOn = isOn
                // bit hacky, just set lastToggled to last off
                lastToggled = isOn ? lastToggled : controlIndexes(rawValue: i)
            }
        }
        if !MFMessageComposeViewController.canSendText() {
            appSendButton.isEnabled = false
            appSendButton.titleLabel?.text = "Not allowed to send texts"
        }
    }

    func matchButtonsToToggles() {
        for (i, isOn) in enabled.enumerated() {
            buttons[i]?.alpha = isOn ? 1.0 : 0.3
        }
    }
    
    func allOff() -> Bool {
        return !enabled.contains(true)
    }
    
    // change value of a switch associated with the emoji button just tapped
    func toggle(_ which:controlIndexes) {
        toggles[which.rawValue]?.toggle()
        // needs to delay after button comes up to make dim
        DispatchQueue.main.asyncAfter(deadline: .now()+0.01) {self.adjustControls(justSet:which)}
    }
    
    func adjustControls(justSet which:controlIndexes) {
        enabled[which.rawValue] = !enabled[which.rawValue]
        if allOff() && lastToggled != nil {
            toggle(lastToggled!)  // radio button behaviour
        }
        matchButtonsToToggles()
        lastToggled = which
        SharedData.current.save(enabled: enabled)
    }
    
    @IBAction func onToggleHappy(_ sender: UISwitch) {
        adjustControls(justSet:.happy)
    }
    
    @IBAction func onToggleQuizzical(_ sender: UISwitch) {
        adjustControls(justSet:.quizzical)
    }
    
    @IBAction func onToggleDistraught(_ sender: UISwitch) {
        adjustControls(justSet:.distraught)
    }
    
    @IBAction func onToggleAngry(_ sender: UISwitch) {
        adjustControls(justSet:.angry)
    }
    
    
    @IBAction func onHappy(_ sender: Any) {
        toggle(.happy)
    }
    
    @IBAction func onQuizzical(_ sender: Any) {
        toggle(.quizzical)
    }
    
    @IBAction func onDistraught(_ sender: Any) {
        toggle(.distraught)
    }
    
    @IBAction func onAngry(_ sender: Any) {
        toggle(.angry)
    }
    
    
    /// see Readme and  https://developer.apple.com/documentation/messageui/mfmessagecomposeviewcontroller
    @IBAction func onAppSendButton(_ sender: Any) {
        displayMessageInterface()
    }
    
    func displayMessageInterface() {
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
            urlComps.queryItems = [URLQueryItem(name:"mood", value:"happy")]
            message.url = urlComps.url
            composeVC.message = message
        }
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
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

