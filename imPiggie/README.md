# imPiggie - Posthog demonstrator

Copy of `imUrlDataApp` [readme about that in the parent folder](../imUrlDataApp/README.md) that adds event logging to [PostHog](https://posthog.com/).

See `imPiggie/Common/PostHogPen.swift` for the setup function.

It relies on a trivial structure not included in GitHub

```
struct imPiggieSecrets {
    static let PostHog_apiKey = "the string you get from PostHog when you sign up"
}
```

The `imPiggie/imPiggie Code Change Diary.txt` describes how the calls to use event logging were added. Note that because an iMessage app extension is a bunch of callbacks, that `setup()` and `flush()` are called relatively often.
