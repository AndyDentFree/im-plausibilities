# imPiggie - Posthog demonstrator

Copy of `imUrlDataApp` [see its readme](../imUrlDataApp/README.md) that adds event logging using [PostHog](https://posthog.com/).

See `imPiggie/Common/PostHogPen.swift` for the setup function.

It relies on a trivial structure not included in GitHub

```
struct imPiggieSecrets {
    static let PostHog_apiKey = "the string you get from PostHog when you sign up"
}
```

The `imPiggie/imPiggie Code Change Diary.txt` describes how the calls to use event logging were added. 

Note that because an iMessage app extension is a bunch of callbacks, that `setup()` and `flush()` are called relatively often.

## About iMessage extensions
If you're here because you're interested in PostHog rather than iMessage, these samples may be a bit confusing.

The extension is packaged with a _host app,_ so if you built and installed this project you would see an imPiggie app on your phone as well as it appearing inside Messages.

An iMessage app extension is a plugin for Apple Messages app. It is invoked from within Messages:
- to Receive a message sent with an extension
  - if you don't have it installed, the Messages app provides a link to install right there in the message bubble
  - when it's installed, tapping the bubble will launch the extension. Depending on the extension, it may just display content in the _compact_ view which takes up the same space as the keyboard. Otherwise, it will expand to fill most of the screen.
- to Send with an extension, you need to pick it from the installed extensions. See [Apple's help on how to get iMessage apps](https://support.apple.com/en-us/104969) as per the screenshot below:

![](https://cdsassets.apple.com/live/7WUAS350/images/ios/ios-17-iphone-15-pro-messages-imessage-app-icon-callout.png)
