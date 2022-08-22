//
//  MessagePickerHost.swift
//  imUrlDataAppSUI
//
//  Created by AndyDent on 8/8/2022.
//  Aided by https://www.hackingwithswift.com/books/ios-swiftui/wrapping-a-uiviewcontroller-in-a-swiftui-view

import Foundation
import SwiftUI
import MessageUI
import Messages

struct MessagePickerHost: UIViewControllerRepresentable {
   
    typealias UIViewControllerType = MFMessageComposeViewController
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
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

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = context.coordinator
        
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
            urlComps.queryItems = [URLQueryItem(name: Mood.moodKey, value:Mood.happy.rawValue)]
            message.url = urlComps.url
            composeVC.message = message
        }
        return composeVC
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {
        // is not used
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    
}
