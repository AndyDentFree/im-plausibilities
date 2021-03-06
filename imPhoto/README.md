# imPhoto
See the overall rationale in the [readme in the parent folder](../README.md).

Created to test using the camera and photo library within an iMessage extension.

This has been cause of problems in the past due to assorted bugs.

Note that this does **not** do any custom sending of photos - the photos are only sent within the Message layout, as if you'd used Apple's own photo iMessage app or another app such as [infltr](http://www.infltr.com/), or sent as an attachment.

Important note that the sendAttachment does **not** send a custom message so when it arrives you can't tell that it came from imPhoto.

## The Camera Bug in XCode 10.1
There's a bug in XCode 10.1 where just **adding the plist key** `NSCameraUsageDescription` **and debugging** will cause your app to crash on exit, which means as you call `dismiss` to transfer control back to iMessage.

`Message from debugger: Terminated due to signal 9`

### Workaround
1. You cannot use the debugger for camera testing.
2. You need to have a separate `info.plist` for Release and Debug builds.

Use the `MessagesExtension runRelease` scheme when testing, to quickly push a Release build (with camera enabled) to your device but remember you **cannot debug it in XCode**

## Icons
There are a couple of icons from [icons8](https://icons8.com/license) used here for the UI and to compose the app icons. Whilst I have a paid license, they should not be re-used in this sample code without attribution as per this clause.

## Project Structure

Created duplicating imUrlData and renaming everything


## Apple Pages

Sample [PhotoPicker](https://developer.apple.com/library/archive/samplecode/PhotoPicker/Introduction/Intro.html#//apple_ref/doc/uid/DTS40010196) used to help understand how to use the [UIImagePickerController](https://developer.apple.com/documentation/uikit/uiimagepickercontroller).
