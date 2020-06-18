# webFromIM
Copied from responIM

See the overall rationale in the [readme in the parent folder](../README.md).

This sample explores just a UI aspect - launching a web browser from within iMessage, nothing to do with messaging.

It also shows using a web view locally in iMessage as you might do for help pages.

Note that the web URL entry field is only enabled in expanded mode (because compact mode doesn't leave room for the keyboard). Yeah this is the easy way out - a nicer UI would be that tapping on that field would auto-expand.

## Launching a URL - iOS 13 Onwards
The approach below was broken deliberately by a new restriction in iOS 13. 

Compiling the app gets an error in XCode-11:

`open(_:options:completionHandler:)' is unavailable in application extensions`

The official workaround, from Apple Developer Support, is to use the parent app to handle the URL. You can still use `self.extensionContext.open` to open the parent app from your extension. That parent app can handle parameters passed on opening, to forward a URL elsewhere or show it in a local WKWebView.

### Launching a URL - Original works in iOS 12
The obvious thing to try is `self.extensionContext.open` which is [documented](https://developer.apple.com/documentation/foundation/nsextensioncontext/1416791-open) as _Asks the system to open a URL on behalf of the currently running app extension._

That doesn't work. However, you can iterate back up the responder chain to find a suitable handler for the open method (actually the iMessage instance) and invoke `open` with that object.

This approach works for URLs which will open a local app, like settings for a camera, or for web URLs.


## Project Structure

Created duplicating responIM and renaming everything

As of 2020-06-18 added a new app target. The initial pure iMessage app extension is a limited "invisible" host app so it's cleaner to start from scratch creating a standard app then add the iMessage extension back into it.

Note that there is **no shared data** between the iMessage extension and the app, unlike `imUrlDataApp`.

The user experience starts in the iMessage app and the only use of the main app is to 

1. Show the web page in the app, or
2. Forward the URL to launch something else.

