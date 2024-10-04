//
//  AuthCamera.swift
//  imUrlDataApp
//
//  Created by Andrew Dent on 4/10/2024.
//  Copyright © 2024 Touchgram Pty Ltd. All rights reserved.
//


import UIKit
import AVFoundation

// copied from imPhoto sample
extension UIViewController {
    
    public func withAuthorisedCamera(_ nextScreen: @escaping ()->Void) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if authStatus == AVAuthorizationStatus.denied {
            // Denied access to camera, alert the user.
            // The user has previously denied access. Remind the user that we need camera access to be useful.
            let alert = UIAlertController(title: "Unable to access the Camera",
                                          message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.",
                                          preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
                // Take the user to Settings app to possibly change permission.
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                /* normal advice for extensions is
                 self.extensionContext?.open(settingsUrl, completionHandler: { (success) in ...
                 extensionContext.open does NOT WORK FROM INSIDE iMessage.
                 however we can go back up the responder chain to get the iMessage parent app
                 */
                let openSel = #selector(UIApplication.open(_:options:completionHandler:))
                var responder = self as UIResponder?
                while (responder != nil){
                    if responder?.responds(to: openSel ) == true{
                        // cannot package up arguments, so assume is a UIApplication and cast
                        (responder as? UIApplication)?.open(settingsUrl, completionHandler:{(success) in
                            if success {
                                print("Successfully opened settings")
                            } else {
                                print("Failed to open Settings")
                            }
                        })
                        return
                    }
                    responder = responder!.next
                }
            })
            alert.addAction(settingsAction)
            
            present(alert, animated: true, completion: nil)
        }
        else if (authStatus == AVAuthorizationStatus.notDetermined) {
            // The user has not yet been presented with the option to grant access to the camera hardware.
            // Ask for permission.
            //
            // (Note: you can test for this case by deleting the app on the device, if already installed).
            // (Note: we need a usage description in our Info.plist to request access.
            //
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted {
                    DispatchQueue.main.async {
                        nextScreen()
                    }
                }
            })
        } else {
            nextScreen()
        }
    }
    
}

