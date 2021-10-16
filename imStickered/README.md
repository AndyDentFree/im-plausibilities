# imStickered
Copied from webFromIM & reworked.

See the overall rationale in the [readme in the parent folder](../README.md).

This sample explores using [Snap's StickerKit][SK] as it allows for using Stickers without login. There will also be a sample exploring [LoginKit] and BitMoji. This simpler one seeks to show the ability to pull in stickers only in the iMessage app extension without worrying about deeplinking callback issues.

Note that this is a sample app under the MIT License (as per `../LICENSE`) so feel free to copy to build your own apps on top of the code here. I may have taken minor shortcuts or engineering approaches inadequate for production apps.

## Snap Integration

Using the [iOS StickerKit Instructions][SKI] but got a bit lost.

For _just_ using StickerKit, you still need to follow part of the instructions.

In the app portal, you need to generate a **Snap Kit API Token** for both _Staging_ and _Production_ which should **not** be checked into public repos like this one!

Note if you're looking on GitHub, the term _SnapKit_ has been overloaded as there was an iOS layout framework named that previously. It's fallen rather by the wayside (especially since SwiftUI came out) but the name loss is forever.

The **Official Snap account** is https://github.com/Snapchat but you won't find any code there to help with StickerKit, possibly because it's a very new offering.

### Testing StickerKit with Postman
I cannot emphasise this too highly - use the [recommended Postman sample][PM] to validate that you have got your API Token correctly setup for StickerKit access. Make sure you can press Send on their examples and get something other than _unauthorised_ before you move on to using code to access StickerKit.

### How we handle auth in this example
There is a file `SnapAuthDoNotSharePublicly.swift` which is included in the XCode project but **never checked into public repos**. A template for this file is included, named `SnapAuthDoNotSharePublicly_copyAndRename.swift`

**Warning** in production apps we discourage including literal strings like this. Sorry, discussion of how to avoid that is out of scope.


[SK]: https://kit.snapchat.com/docs/sticker-kit
[LoginKit]: https://kit.snapchat.com/docs/login-kit
[SKI]: https://kit.snapchat.com/docs/sticker-kit-ios
[CT]: https://kit.snapchat.com/docs/downloads
[PM]: https://www.postman.com/jjdharmaraj/workspace/snap-kit/request/14285716-87d8c29e-2ea1-4abb-98c1-82df686b3f99
