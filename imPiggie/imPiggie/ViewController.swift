//
//  ViewController.swift
//  imPiggie
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
    
    lazy var toggles = [happySwitch, quizzicalSwitch, distraughtSwitch, angrySwitch] // maintains same order as Mood
    lazy var buttons = [happyBtn, quizzicalBtn, distraughtBtn, angryBtn]
    var lastToggled : controlIndexes? = nil
    var messager = MessageComposingHelper()
    var lastTappedMood = Mood.happy

    // array of flags instead of storing state in the switch so can easily save and load
    var enabled = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        enabled = SharedData.current.loadEnabled()
        // initial loading loop - if read at least one false
        if enabled.contains(false) {
            var firstOn: Mood? = nil
            for (i, isOn) in enabled.enumerated() {
                if isOn && firstOn == nil {
                    firstOn = Mood[i]
                }
                buttons[i]?.alpha = isOn ? 1.0 : 0.3
                buttons[i]?.isEnabled = isOn
                toggles[i]?.isOn = isOn
                // bit hacky, just set lastToggled to last off
                lastToggled = isOn ? lastToggled : controlIndexes(rawValue: i)
            }
            lastTappedMood = firstOn ?? .happy
        }
        if !messager.canSendText() {
            appSendButton.isEnabled = false
            appSendButton.titleLabel?.text = "Not allowed to send texts"
        }
        tap(mood: lastTappedMood)  // just to get it highlighted
        PostHogPen.trough?.capture("app visible")
    }

    func matchButtonsToToggles() {
        for (i, isOn) in enabled.enumerated() {
            buttons[i]?.alpha = isOn ? 1.0 : 0.3
            buttons[i]?.isEnabled = isOn
        }
    }
    
    
    func buttonFor(mood: Mood) -> UIButton {
        switch mood {
        case .happy:
            return happyBtn
        case .quizzical:
            return quizzicalBtn
        case .distraught:
            return distraughtBtn
        case .angry:
            return angryBtn
        }
    }
    
    func tap(mood: Mood) {
        buttonFor(mood: lastTappedMood).layer.borderWidth = 0
        buttonFor(mood: mood).layer.borderWidth = 4
        if #available(iOS 13.0, *) {
            buttonFor(mood: mood).layer.borderColor = CGColor(red: 099, green: 0.6, blue: 0.05, alpha: 1.0)
        } else {
            // Fallback on earlier versions
        }
        lastTappedMood = mood
        PostHogPen.trough?.capture("tapped", properties: ["mood": mood.rawValue])
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
        tap(mood: .happy)
    }
    
    @IBAction func onQuizzical(_ sender: Any) {
        tap(mood: .quizzical)
    }
    
    @IBAction func onDistraught(_ sender: Any) {
        tap(mood: .distraught)
    }
    
    @IBAction func onAngry(_ sender: Any) {
        tap(mood: .angry)
    }
    
    
    /// see Readme and  https://developer.apple.com/documentation/messageui/mfmessagecomposeviewcontroller
    @IBAction func onAppSendButton(_ sender: Any) {
        PostHogPen.trough?.capture("send pressed to display message interface")
        messager.displayMessageInterface(onVC: self, mood: lastTappedMood)
    }

    @IBAction func onFlushButton(_ sender: Any) {
        PostHogPen.trough?.flush()
    }
}

