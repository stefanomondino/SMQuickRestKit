SMQuickRestKit
==============

SMQuickRestKit is an easy wrapper to quickly setup a client/server application in Objective-C
It's based on Blake Watters' RestKit, a huge library who can manage URL connections (via AFNetworking), object-mapping of any text data (JSON, XML and other formats) into native objective-c objects (models) and simple persist them into Core Data in a very simple way.  
SMQuickRestKit handles common project configuration so that you can focus on your development and spend less time over object-mappings.
Base configuration also includes MagicalRecord auto setup, so that you can easily query your core data entities with a single line of code.

Features
========

*   Full integration with RestKit
*   Seamless integration with MagicalRecord and CoreData
* 	Setup your mappings at startup (in the AppDelegate) and never think again about them

Installation
============

Installation is handled by CocoaPods.
Add this line to your podfile

	pod 'SMQuickRestKit',:git => 'https://github.com/stefanomondino/SMQuickRestKit.git', :branch => 'master'


Usage
=====
*   Create your model(s) by subclassing SMUnsavedModel if you DON'T want it to be CoreData persisted, otherwise subclass SMSavedModel.

*   Define your model by adding all the properties you need (setup your data model too if you need CoreData persistance)

* 	Override (void)setupMapping:(RKObjectMapping *)mapping forBaseurl:(NSString *)baseurl and setup your RKObjectMapping/RKEntityMapping here with RestKit methods

*	In your AppDelegate, init a SMQuickObjectMapper (with or without coreData flag) for each baseurl you will need. You can also set a custom serialization class for different mimetypes (in my example, RKNSJSONSerialization for text/javascript according to Apple Search API )

*	For each model, setup a mapping providing a keypath (use @"" if you want to map remote object from root) and the remote baseurl/path where you will find it

*	Use NSObject+SMQuickDownload to download remote objects from any class in your code! Override the success/failure methods to use mapping result and you are ready to go!


Example
=======

You will find a detailed example in the "Example" folder