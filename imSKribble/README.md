# imSKribble
See the overall rationale in the [readme in the parent folder](../README.md).

This sample shows a problem encountered with the new Sheet model in Messages in iOS17 and a workaround.

It uses a touch tracked in SpriteKit that captures a scribble. That code was copied from [SKScribbles][1]

Like imDataUrl the data is sent using the URL field.

## Drawing
Lines traced locally are drawn in blue, incoming lines in green.

The explicit **Send** and **Clear** buttons send the points last drawn or clear the known points.

To keep things simpler, only one set of points are retained for sending.

Note that this is not completely _live_ drawing back and forth. The drawing side was got working enough to encounter the iOS17 bug. If you have imSkribble open on one phone and send a message from the other it should trigger a `didReceive` and you have back-and-forth comms for some time.

See also [MSMessageLiveLayout][2] for an alternative for live messaging inside a bubble in the transcript.



## The iOS17 Messages app change
The change (on instructions from DTS) is very simple. Replace the use of `SKView` with a trivial subclass that prevents Pan gestures.

See `MessagesCompensatingSKView.swift`:

```
class MessagesCompensatingSKView: SKView {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        !(gestureRecognizer is UIPanGestureRecognizer)
    }
}
```

## Other notes
The deployment target is 12.1 because I have a bunch of old devices for testing. This causes some warnings about missing button features but has no runtime side-effects.


## Project Structure

Copied imDataUrl and renamed everything.

[1]: https://github.com/AndyDentFree/SpriteKittenly/tree/master/SKScribbles
[2]: https://developer.apple.com/documentation/messages/msmessagelivelayout