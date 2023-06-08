# imUrlEvolvUI
See the overall rationale in the [readme in the parent folder](../README.md).

SwiftUI availability in a UIKit app.

The basic app and iMessage app extension is compatible with iOS12.

It uses SwiftUI with availability check.

It also demonstrates compact vs expanded modes for the iMessage extension, with the expanded view being a list of items sent. This list is done separately with SwiftUI if available.

It has a delete option which sends a delete command. That will animate the item being deleted by the other party. This is the most vulnerable thing with Touchgram and moving to SwiftUI.

Then try adding IAP to an iMessage sample so can explore the issues around that.
