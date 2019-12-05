# webFromIM
Copied from responIM

See the overall rationale in the [readme in the parent folder](../README.md).

This sample explores just a UI aspect - launching a web browser from within iMessage, nothing to do with communications.


## Launching a URL
The obvious thing to try is `self.extensionContext.open` which is [documented](https://developer.apple.com/documentation/foundation/nsextensioncontext/1416791-open) as _Asks the system to open a URL on behalf of the currently running app extension._

That doesn't work. However, you can iterate back up the responder chain to find a suitable handler for the open method (actually the iMessage instance) and invoke `open` with that object.

This approach works for URLs which will open a local app, like settings for a camera, or for web URLs.

## Project Structure

Created duplicating responIM and renaming everything
