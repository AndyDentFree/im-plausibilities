# im-plausibilities
Explorations of apps for Apple's iMessage

## Many tiny apps rationale
Due to some painful debugging experiences, I took the approach of doing simplest-possible testbed apps for different technologies.

This means if you are interested in a given sample, there's a better chance of it continuing to work than if you have to fix bugs in areas not of interest.

For that reason, unless testing 3rd-party tech, in general this is pure Apple stuff alone.

In many cases, there are snippets and documentation explaining bits of code but no full sample you can build and verify works.

Each will have its own nested readme document.

* [Sending data via a URL](./imUrlData/README.md)
* [Responding within a message](./responIM/README.md)


## Other Rationales

### Icons
Even though these are relatively trivial test apps, I take the time to add a unique icon to them. 

I have found, when you have more than one test app, especially with minimal UI, being able to pick the icon avoids stupid mistakes. In particular, with iMessage apps, icons need to stand out in the app picker strip.

I created a Sketch file initially in the imUrlData sample which is based off Apple's icon template (as of Sketch 52.6) but extended a bit for the iMessage icon sizes which are non-square. 

## History

This started as a private repo (thanks MS/GitHub for introducing these) so I could work up some tests without public embarrassment then decide to publish.

So, if you are reading this,I got enough material to publish and you can probably read an article or two [somewhere on Medium](https://medium.com/@andydentperth)

