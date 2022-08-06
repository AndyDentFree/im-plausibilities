//
//  ViewController.swift
//  imUrlDataApp
//
//  Created by Andrew Dent on 17/1/19.
//  Copyright © 2019 Touchgram Pty Ltd. All rights reserved.
//

import UIKit

extension UISwitch {
    func toggle() {
        self.setOn(!self.isOn, animated: true)
    }
}

class ViewController: UIViewController {
    
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
    var messager = MessageComposingHelper()

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
        if !messager.canSendText() {
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
        messager.displayMessageInterface(onVC: self)
    }

}

