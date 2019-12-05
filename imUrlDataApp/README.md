# imUrlDataApp
See the overall rationale in the readme in the parent folder.

Same as imUrlData but adding a usable iOS App side rather than just appearing as an extension.


## Shared Features
We are not trying to share any significant logic between the two sides. One complicating factor is that MessagesViewController is a MSMessagesAppViewController.

If we wanted to have common UI would need it to be nested ViewControllers inside that.

However, to make it interesting, we **do** want the app to influence the behaviour of the message extension, so we allow it to set _which moods_ are available. The values are stored in a simple plist file, managed by `SharedData.swift` and both app and extension are members of an _AppGroup_.

This mimics a common pattern - put the _Settings_ features into the main app.

Note another strong reason to have the companion app installable is to support In-App Purchases as these are not officially supported in iMessage extensions.

| App with two buttons disabled | Messenger showing matching state |  
|:------:|:------:|  
| ![App with two moods disabled](img/imUrlDataApp_app_only_happy_enabled.png) |  ![Matching messenger](img/imUrlDataApp_msg_only_happy_enabled.png) |



## Project Structure

Created using XCode 10.1 as a Single View App then *added* an iMessage App Extension second target.

**Important Note** When you create an iMessage app like imUrlData you have a .app target generated as part of the project. However, that's a very specialised host for the iMessage App Extension and can **not** be converted into a standard app.

The way to go is as shown in this sample - start with a _normal_ app and **add** an iMessage App Extension to it.

If you look in the git history of this sample you will see how I made the mistake of starting with a plain copy of imUrlData and tried to modify its app into a real one. On realising, and researching, that this is impossible, I started over with a Single View App.