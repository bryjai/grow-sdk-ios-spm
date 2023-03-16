# Grow SDK for iOS v1.1.1

## Requirements

Requires Xcode 12.5 or above.

---

## Installing the SDK

### Install using Swift Package Manager

This is the recommended way to install our SDK, this allows you to easily upgrade versions.

1. Add the following package dependency url to your project by following the [Apple documentation](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app):

```
https://github.com/bryjai/grow-sdk-ios-spm
```

2. Select **Exact Version** as **Dependency Rule** and make sure the last SDK version is displayed:

![Grow SDK iOS SPM](https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/add-grow-sdk-spm.png)

3. Choose your main application target:

![Grow SDK iOS SPM Choose Target](https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/choose-target-for-spm.png)

2. If you use Xcode 13 or lower, in the project settings, add the **GrowSDK** framework into **Frameworks and Libraries** for each application and extension target where you want to use the SDK.

4. If you use Xcode 14, no additional configuration is needed


### Install manually

1. Download the **GrowSDK 1.1.1** framework archive [here](https://s3-eu-west-1.amazonaws.com/bryj-sdks/ios/1.1.0/Grow-SDK-iOS-1.1.1.xcframework.zip)

2. Unzip the downloaded archive

3. Drag and drop the resulting **xcframework** file into your Xcode project. There is no specific place you need to drop it, but if you have the Frameworks group you can drop there. When prompted with the `Choose options for adding these files` make sure to check `Copy items if needed` and select all the applications and extensions targets you want to add the SDK to:

![Grow SDK iOS manual install 1](https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/manual_step_1.png)

4. For the application target make sure `Embed & Sign` is selected for the `GrowSDK.xcframework`:

![Grow SDK iOS manual install 2](https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/manual_step_2.png)

5. And for the extension make sure `Do Not Embed` is selected for the `GrowSDK.xcframework`:

![Grow SDK iOS manual install 3](https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/manual_step_3.png)


### Define capabilities

In order to make the SDK fully functional, it requires the developer to configure capabilities on the **Application** target **and** as well on the **Extension** target. The required capabilities are:

- [Push Notifications](https://developer.apple.com/documentation/usernotifications/registering_your_app_with_apns)
- [Background Modes](https://developer.apple.com/documentation/xcode/configuring-background-execution-modes). Select options **Background fetch** and **Remote notifications**.
- [App Group](https://developer.apple.com/documentation/xcode/configuring-app-groups)


**Caution: the `App Group` name needs to be the same on both Application and Extension targets.**

To learn more about capabilities please check [Apple documentation](https://developer.apple.com/documentation/xcode/capabilities).

### Enable device registration

```
Registering devices enables users of the Bryj platform to test their campaigns and check data collection. Unlike Android, you need to declare the URL scheme on your app on iOS to benefit from this feature.
```

To allow the user to retrieve the device ID to enable Grow debug features, declare a URL Scheme in the info tab of your Xcode project using the bundleId of your app as URL Scheme:

1. Go to the info tab of the project targets.
2. At the bottom you select the subsection called “URL Types”.
3. Click the + sign at the bottom.
4. Add the bundle ID of your app in both identifier and URL Schemes fields.

![URL Scheme](https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/url_scheme.png)

### Enable the Grow refresh task

This is important to allow the Grow SDK to execute tasks when the app is in background.

In the **Info.plist** file of your app, add the `ai.bryj.grow.background.refresh` string item to the **Permited background task scheduler identifiers** array (which should be added if not already present in your file):

![Background Tasks Scheduling](https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/background-task-scheduler.png)

---

## Initializing the SDK

### Initialize on the Application

To configure the SDK, it is required an **API Key** provided by the platform and the [**App Group**](# Define capabilities) configured on your Xcode project. Without the App Group, the SDK will not provide "Push+Landing" campaigns to your application.

In your AppDelegate class file, import the **GrowSDK** framework:

#### Swift
```swift
import GrowSDK
```

#### Objective-C
```objective-c
#import <GrowSDK/GrowSDK-Swift.h>
```

Still in this `AppDelegate` file find the method `application(_:didFinishLaunchingWithOptions:)` and on it create a **AppConfigurationBuilder** instance from the GrowSDK framework. This instance will allow you to generate through the `build()` method the required **AppConfiguration** to be passed in the static method `start(_:options:)` of the main class `Grow`. This static method also requires the launchOptions.

In the example below, a `AppConfigurationBuilder` is instantiated with the mandatory `apiKey` provided by the platform, and the mandatory `appGroup` configured by the developer on Xcode:

#### Swift
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let configuration = Grow.AppConfigurationBuilder(apiKey: "YOUR_API_KEY", appGroup: "YOUR_APP_GROUP")
                             .build()
    Grow.start(configuration: configuration, options: launchOptions)
    
    // ...
    
    return true
}
```

#### Objective-C
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    id <AppConfiguration> configuration = [[[AppConfigurationBuilder alloc]
                                             initWithApiKey:@"YOUR_API_KEY"
                                             appGroup:@"YOUR_APP_GROUP"]
                                            build];
    
    [Grow startWithConfiguration:configuration options:launchOptions];
    
    // ...
    
    return YES;
}
```


### Initialize on the Notification Service extension

In order to handle Grow Push campaigns, you must add a [**Notification Service** extension](https://developer.apple.com/documentation/usernotifications/modifying_content_in_newly_delivered_notifications) to your app.

If you use SPM in Xcode 13 and lower, or if you added the SDK manually, make sure to  have the `GrowSDK` framework included in the **Frameworks and Libraries** for your Notification Service target, with the **Do Not Embed** option.

Open your Notification Service class, which extends `UNNotificationServiceExtension`, and add the following code to it:

1. Declare a new `service` property of type `GrowNotificationService?` which will store the Grow SDK Notification Service instance.
2. In the method `didReceive(_:withContentHandler:)`, create an `ExtensionConfigurationBuilder` instance by passing your **App Group** and your main **App Bundle Identifier** to the constructor, and call its `build()` method to generate an actual `ExtensionConfiguration`.
3. Then call `Grow.didReceive(_:forConfiguration:withContentHandler:)` to retrieve the Grow SDK Notification Service instance and store it into the `service` property previously created. Make sure to pass to this method the `request` and `contentHandler` arguments from the caller method, as well as the `ExtensionConfiguration` created at step 2.
4. In the method `serviceExtensionTimeWillExpire()`, Call `service?.serviceExtensionTimeWillExpire()`.

```
It's important that you pass your main app target Bundle Identifier to the Grow SDK Notification Service appBundleIdentifier argument on the constructor. This allows Grow SDK to be compatible with projects using the same extension target into several app targets while all are using the same App Group.
```

Your extension class should look like the following:

#### Swift
```swift
import UserNotifications
import GrowSDK

class NotificationService: UNNotificationServiceExtension {
    
    var service: GrowNotificationService?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        let configuration = Grow.ExtensionConfigurationBuilder(appGroup: "YOUR_APP_GROUP",
                                                               appBundleIdentifier: "YOUR_MAIN_APP_BUNDLE_IDENTIFIER").build()
        service = Grow.didReceive(request, forConfiguration: configuration, withContentHandler: contentHandler)
    }
    
    override func serviceExtensionTimeWillExpire() {
        service?.serviceExtensionTimeWillExpire()
    }
}
```

#### Objective-C
```objective-c
#import <GrowSDK/GrowSDK-Swift.h>

@interface NotificationService ()
@property (nonatomic, strong) GrowNotificationService *service;
@end

@implementation NotificationService
    
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {

    id <ExtensionConfiguration> configuration = [[[ExtensionConfigurationBuilder alloc]
                                                   initWithAppGroup:@"YOUR_APP_GROUP"
                                                   appBundleIdentifier:@"YOUR_MAIN_APP_BUNDLE_IDENTIFIER"]
                                                  build];
    self.service = [Grow didReceive:request forConfiguration:configuration withContentHandler:contentHandler];
}

- (void)serviceExtensionTimeWillExpire {
    [self.service serviceExtensionTimeWillExpire];
}
@end
```

If you need to implement the `didReceive(_:withContentHandler:)` method on your **Notification Service** extension, you must ensure to forward the call before your code.
