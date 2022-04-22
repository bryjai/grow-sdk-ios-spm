# Grow SDK for iOS v1.0.1

## Requirements

Requires Xcode 12.5 or above.

---

## Installing the SDK

### Install using Swift Package Manager

This is the recommended way to install our SDK, this allows you to easily upgrade versions.

Add the following package dependency url to your project by following the [Apple documentation](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app):

```
https://github.com/bryjai/grow-sdk-ios-spm
```


### Install manually

Having access to the **GrowSDK.xcframework**  you can integrate the SDK manually. To do that you just need to drag and drop this file into your Xcode project. There is no specific place you need to drop, but if you have the Frameworks group you can drop there. When prompted with the `Choose options for adding these files` make sure you mark `Copy items if needed` and select your application and extension targets. If you have several application targets and want to use the SDK on them check those targets as well.

![Grow SDK iOS manual install 1](https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/manual_step_1.png)

For the application target make sure `Embed & Sign` is selected for the `GrowSDK.xcframework`.

![Grow SDK iOS manual install 2](https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/manual_step_2.png)

And for the extension make sure `Do Not Embed` is selected for the `GrowSDK.xcframework`.

![Grow SDK iOS manual install 3](https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/manual_step_3.png)


### Define capabilities

In order to make the SDK fully functional, it requires the developer to configure capabilities on the **Application** target **and** as well on the **Extension** target. The required capabilities are:

- [Push Notifications](https://developer.apple.com/documentation/usernotifications/registering_your_app_with_apns)
- [Background Modes](https://developer.apple.com/documentation/xcode/configuring-background-execution-modes). Select options **Background fetch**, **Remote notifications**, and **Background processing**.
- [App Group](https://developer.apple.com/documentation/xcode/configuring-app-groups)


**Caution: the `App Group` name needs to be the same on both Application and Extension targets.**

To learn more about capabilities please check [Apple documentation](https://developer.apple.com/documentation/xcode/capabilities).

---

## Initializing the SDK

### Initialize on the Application

To configure the SDK, it is required an **API Key** provided by the platform and the [**App Group**](# App Group) configured on your Xcode project. Without the App Group, the SDK will not provide "Push+Landing" campaigns to your application.

Now open your's AppDelegate class file and import the **GrowSDK** framework.

#### Swift
```swift
import GrowSDK
```

#### Objective-C
```objective-c
#import <GrowSDK/GrowSDK-Swift.h>
```

In the same file find the method `application(_:didFinishLaunchingWithOptions:)` and on it create a **Configuration** object from the GrowSDK framework. This object receives a lambda function to provide the possible configurations to be used on the initialization of SDK.

Having this object created you now pass it to the static method `start(_:options:)` of the main class `Grow` of the SDK. This static method also requires the launchOptions.

#### Swift
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let _configuration = Grow.AppConfigurationBuilder(apiKey: "YOUR_API_KEY", appGroup: "YOUR_APP_GROUP")
                             .build()
    Grow.start(configuration: _configuration, options: launchOptions)
    
    // ...
    
    return true
}
```

#### Objective-C
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    id <AppConfiguration> _configuration = [[[AppConfigurationBuilder alloc]
                                             initWithApiKey:@"YOUR_API_KEY"
                                             appGroup:@"YOUR_APP_GROUP"]
                                            build];
    
    [Grow startWithConfiguration:_configuration options:launchOptions];
    
    // ...
    
    return YES;
}
```


### Initialize on the Notification Service extension

In order to handle Grow Push campaigns, you must add a **Notification Service** extension to your app. This extension should extends our `GrowNotificationService` class instead of the Apple `UNNotificationServiceExtension`. Then you need to implement the `configuration()` method to setup the Grow SDK on the extension.

Your notification service extension class should look like this.

#### Swift
```swift
import UserNotifications
import GrowSDK

class NotificationService: UNNotificationServiceExtension {
    
    var service: GrowNotificationService?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        let _configuration = Grow.ExtensionConfigurationBuilder(apiKey: "YOUR_API_KEY",
                                                              appGroup: "YOUR_APP_GROUP",
                                                   appBundleIdentifier: "YOUR_APP_BUNDLE_IDENTIFIER")
                                 .build()
                                 
        service = Grow.didReceive(request, forConfiguration: _configuration, withContentHandler: contentHandler)
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

    id <ExtensionConfiguration> _configuration = [[[ExtensionConfigurationBuilder alloc]
                                                   initWithApiKey:@"YOUR_API_KEY"
                                                   appGroup:@"YOUR_APP_GROUP"
                                                   appBundleIdentifier:@"YOUR_APP_BUNDLE_IDENTIFIER"]
                                                  build];
    
    self.service = [Grow didReceive:request forConfiguration:_configuration withContentHandler:contentHandler];
}

- (void)serviceExtensionTimeWillExpire {
    [self.service serviceExtensionTimeWillExpire];
}
@end
```

If you need to implement the `didReceive(_:withContentHandler:)` method on your **Notification Service** extension, you must ensure to forward the call before your code.
