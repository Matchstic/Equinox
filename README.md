Equinox
=======

Built using iOSOpenDev - some modification is required for use with theos.

- - - 

Equinox allows for easy theming of the images that WinterBoard cannot. It also provides an 
on-device dumping utility to extract .car images, but it's recommended to use the extractor
by Alexander Zielenski [here](https://github.com/alexzielenski/ThemeEngine).

Designers, please read the `README-Designers.pdf` file for information on how to use this, and
an example theme can be found in the `Tests` folder.

Pre-release debs can be found [here](https://github.com/Matchstic/Equinox/releases).

- - - 

Under the hood, this hooks into `CoreUI.framework` and then returns alternate images out of 
`CUICatalog`. For .artwork files though, different hooks are used, such as into `PrefsListController`
for `iconCache.artwork`.

Currently, this is written to run alongside WinterBoard, and so refers to WB's preferences
to determine where to load Equinox images from. Please refer to the `Tests` folder
for an example of how Equinox themes are set up.

There are still things that need to be worked on;

- Load iconCache images from WinterBoard themes as per in the `Tests` folder
- Improve caching of images
- Small bug fixes relating to preferences on iOS 8
- Handle all other .artwork files
- Possible support for theming `UIToolbar`, `UIAlertView` etc with images

However, in it's current state it does work nicely.

- - -

`Released under the 2-clause BSD license.`
