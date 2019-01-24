# imPhoto
See the overall rationale in the readme in the parent folder.

Created to test using the camera and photo library within an iMessage extension.

This has been cause of problems in the past due to assorted bugs.

Note that this does **not** do any custom sending of photos - the photos are only sent within the Message layout, as if you'd used Apple's own photo iMessage app or another app such as [infltr](http://www.infltr.com/), or sent as an attachment.

Important note that the sendAttachment does **not** send a custom message so when it arrives you can't tell that it came from imPhoto.

## Icons
There are a couple of icons from [icons8](https://icons8.com/license) used here for the UI and to compose the app icons. Whilst I have a paid license, they should not be re-used in this sample code without attribution as per this clause.

## Project Structure

Created duplicating imUrlData and renaming everything


## Apple Pages

Sample [PhotoPicker](https://developer.apple.com/library/archive/samplecode/PhotoPicker/Introduction/Intro.html#//apple_ref/doc/uid/DTS40010196) used to help understand how to use the [UIImagePickerController](https://developer.apple.com/documentation/uikit/uiimagepickercontroller).