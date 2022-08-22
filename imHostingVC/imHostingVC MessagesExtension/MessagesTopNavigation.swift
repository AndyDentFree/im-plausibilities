//
// Created by Andrew Dent on 27/8/18.
// Copyright (c) 2018 Touchgram Pty Ltd. All rights reserved.
//

import Foundation
import UIKit
import Messages
import os.log

/// separates out navigation from simple content in the top VC
/// child screens may require compact or expanded mode
/// also handles a fallback when the user changes expanded <-> compact by dragging
/// or tapping the bar at top of area
extension MessagesViewController: NavCommandDelegate {

    /// Reason for navigating into last full-screen activity from a menu
    /// Note that collapsing to a compact menu doesn't set this value!
    static var lastReason = NavReason.menu

    /// Singleton supporting access without assignign navUsing property which is now deprecated
    fileprivate static var currentDelegate : NavCommandDelegate!

    static func initNavSingleton(with withVC: MessagesViewController) {
        guard MessagesViewController.currentDelegate == nil else {return}
        MessagesViewController.currentDelegate = withVC
    }

    static func current() -> NavCommandDelegate {
        MessagesViewController.currentDelegate!
    }

    func navigate(because: NavReason) {
        MessagesViewController.initNavSingleton(with: self)
        MessagesViewController.lastReason = because
        if presentationStyle == .compact && because.needsToBeExpanded() {
            requestPresentationStyle(.expanded)  // get MSMessagesAppViewController to invoke  presentViewController(for: MSConversation, with:MSMessagesAppPresentationStyle
        } else {
            // transitioning at same level of compact vs full which will often be full -> full
            presentViewController(for: activeConversation, with: presentationStyle)
        }
    }

    func navigateBack() {
        navigate(because: .menu)  // simple case only goes back to menu, not changing expanded vs compact
    }

    /// this factory gets called because of user action causing nav or just collapse/expand pane
    /// maybe unintentionally.
    /// It doesn't know or care if a given VC requires or prefers compact/expanded
    func makeVC(with presentationStyle: MSMessagesAppPresentationStyle) -> UIViewController {
        var vcReason = MessagesViewController.lastReason
        if presentationStyle == .compact {  // gets back to menu by shrinking any other view, probably just user chose to collapse
            if vcReason.needsToBeExpanded() {
                vcReason = .menu  // collapse expanded screens to menu if they can't handle compact, otherwise keep the VC
            }
        }
        typealias NavTargetVC = UIViewController & NavCommandTarget
        var ret:NavTargetVC? = nil
        // if you have complex state transitions may have extra logic here dependong on lastReason
        switch vcReason {
        case .food:
            ret = NestedExpandedViewController(nibName: "NestedExpandedViewController", bundle: nil)

        case .menu:
            ret = MenuViewController(nibName: "MenuViewController", bundle: nil)

        case .mood:
            ret = NestedCompactViewController(nibName: "NestedCompactViewController", bundle: nil)

        default:
            os_log("makeVC should not find itself in a default condition, traversing %{public}s", String(reflecting:MessagesViewController.lastReason))
        }
        return ret!
    }
}
