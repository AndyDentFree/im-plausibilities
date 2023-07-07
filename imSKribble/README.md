# imSKribble
See the overall rationale in the [readme in the parent folder](../README.md).

This sample shows a problem encountered with the new Sheet model in Messages in iOS17 and a workaround.

It uses a touch tracked in SpriteKit that captures a scribble. That code was copied from [SKScribbles][1]

Like imDataUrl the data is sent using the URL field.

## Drawing
Lines traced locally are drawn in blue, incoming lines in green.

The explicit **Send** and **Clear** buttons send the points last drawn or clear the known points.

To keep things simpler, only one set of points are retained for sending.



## Project Structure

Copied imDataUrl and renamed everything.

[1]: https://github.com/AndyDentFree/SpriteKittenly/tree/master/SKScribbles
