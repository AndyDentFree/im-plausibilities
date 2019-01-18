# imUrlDataApp
See the overall rationale in the readme in the parent folder.

Same as imUrlData but adding a usable iOS App side rather than just appearing as an extension.

## Shared Features
We are not trying to share any significant logic between the two sides. One complicating factor is that MessagesViewController is a MSMessagesAppViewController.

If we wanted to have common UI would need it to be nested ViewControllers inside that.

However, to make it interesting, we **do** want the app to influence the behaviour of the message extension, so we allow it to set _which moods_ are available.

This mimics a common pattern - put the _Settings_ features into the main app.

Note another strong reason to have the companion app installable is to support In-App Purchases as these are not officially supported in iMessage extensions.



## Project Structure

Created using XCode 10.1 as a Single Pa1ge App.

