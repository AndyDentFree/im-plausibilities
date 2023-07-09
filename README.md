# im-plausibilities
Explorations of apps for Apple's iMessage

Much of this work was during development of the [Touchgram messaging platform](https://www.touchgram.com/).

## Many tiny apps rationale
Due to some painful debugging experiences, I took the approach of doing simplest-possible testbed apps for different technologies.

This means if you are interested in a given sample, there's a better chance of it continuing to work than if you have to fix bugs in areas not of interest. It also means you can submit a PR to fix a single sample, so is less work to contribute ;-)

In many cases, Apple's documentation provides snippets and API documentation but no full sample you can build and verify works.

## Samples
Each sample will have its own nested readme document.

### URL focus
* [imUrlData - Sending data via a URL](./imUrlData/README.md)
* [imUrlDataApp - Sending data via a URL with app](./imUrlDataApp/README.md) extends `imUrlData` adding a companion app and **shared state** between the app and iMessage extension so the app changes settings affecting the UI in iMessage
* [imUrlDataAppSUI - re-implemented with SwiftUI 3](./imUrlDataAppSUI/README.md) exercise in SwiftUI confirming can be used inside an iMessage extension

### Live messaging
* [responIM - Responding within a message](./responIM/README.md) 
* [imSkribble - Simple sketches going back and forth](./imSKribble/README.md) shows **iOS17** side-effect with gestures.

### Other APIs and complications
* [imPhoto - Using the camera](./imPhoto/README.md) and just sending in the message layout as normal media
* [webFromIM - Launching a Web URL](./webFromIM/README.md) apparently trivial demo that you **can** launch Safari with a website from inside an iMessage extension.


### Opening other apps from inside iMessage
For various reasons, some of these samples may need to launch another app. This became difficult with iOS 13 so these samples were revisited.

* [imPhoto](./imPhoto/README.md) launch Settings to change camera permissions
* [imUrlDataApp](./imUrlDataApp/README.md) launches the companion app, just to show it's possible.
* [webFromIM](./webFromIM/README.md) sole reason for this demo is to launch Safari.

### Planned apps
Note the presence of an idea below is **not** a guarantee the idea is feasible or that I have time to attend to it!

* A pure app version of `imPhoto` that uses `MFMessageComposeViewController` to test sending without going into iMessage
* Sending a photo as special data via a cloud service, so the receiving app can process it
* Sending photos using `MSMessageLiveLayout` to continuously update in the transcript

Also, any nested folders in this repo which are not linked above may be incomplete samples. Please add an issue if you think something should be mentioned here, I may have just forgotten it. Also add issues for anything that is unclear in the docs or source!

## Other Rationales
I love the effort some people put into their sample code but it's often frustrating when they explore several things at once. _I'm testing this API **and** learning Reactive Cocoa_ because those complex samples tend to be left to wither - they are too hard to maintain when someone loses interest.

Some of the sample code might be factored out into multiple classes or extensions in a real app but I find it easier to browse when all is in one file.

Keeping a very similar code layout between different samples should also make it easier for you to compare and see how they differ. That's why the default view controller hasn't been renamed.

### Icons
Even though these are relatively trivial test apps, I take the time to add a unique icon to them. 

I have found, when you have more than one test app, especially with minimal UI, being able to pick the icon avoids stupid mistakes. In particular, with iMessage apps, icons need to stand out in the app picker strip.

I created a Sketch file initially in the imUrlData sample which is based off Apple's icon template (as of Sketch 52.6) but extended a bit for the iMessage icon sizes which are non-square. 

I wouldn't regard myself as more than a very amateur designer. Even with that disclaimer, these do not represent my best work! 

## History

This started as a private repo (thanks MS/GitHub for introducing these) so I could work up some tests without public embarrassment then decide to publish.

I made it public so I could link to it from some Stack Overflow answers. In the near future there will also be articles on iMessage programming [somewhere on Medium](https://medium.com/@andydentperth)

## Disclaimer

These are very simple _technical exploration_ apps. Some of the coding in them is simpler and may take minor shortcuts or lack error checking. Please don't judge me harshly by them. I'm sure there are smarter Swift idioms I could have used in some cases.
