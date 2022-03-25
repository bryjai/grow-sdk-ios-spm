# Grow SDK

This repository contains all the source code to generate the framework to be used both on the application side and on the extension side.

Inside of the project, we also have the source code for the Mobile Application that demonstrates the usage of the framework.

## Installation

Currently, the SDK can be configured through the [Swift Package Manager](https://swift.org/package-manager/) and manually.

### Requirements

- Requires Xcode 12.5 or above.

### Installing from Xcode

Add a package by selecting `File`→`Swift Packages`→`Add Package Dependency...` in Xcode`s menu bar.

---

Search for the **GrowSDK** using the repo`s URL, then press **Next**.

```console
https://github.com/bryjai/grow-sdk-ios-spm
```

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/spm_step_1.png">

---

Set the **Dependency Rule** to `Branch`, then press **Next**.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/spm_step_2.png">

---

Select the **GrowSDK** framework and pick your application Target.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/spm_step_3.png">

On your application target you should have the **GrowSDK** on the **Frameworks and Libraries**.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/spm_step_4.png">

---

Now select your extension target. And from the **Frameworks and Libraries** add the same **GrowSDK** framework.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/spm_step_5.png">



---

### Installing Manually

Having access to the **GrowSDK.xcframework**  you can integrate the SDK manually. To do that you just need to drag and drop this file into your Xcode project. There is no specific place you need to drop, but if you have the Frameworks group you can drop there. When prompted with the `Choose options for adding these files` make sure you mark `Copy items if needed` and select your application and extension targets. If you have several application targets and want to use the SDK on them check those targets as well.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/manual_step_1.png">

For the application target make sure `Embed & Sign` is selected for the `GrowSDK.xcframework`.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/manual_step_2.png">

And for the extension make sure `Do Not Embed` is selected for the `GrowSDK.xcframework`.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/manual_step_3.png">



---

## Configuration

### Setup the SDK on the Application

To configure the SDK, it is required an **API Key** provided by the platform and the [**App Group**](# App Group) configured on your Xcode project. Without the App Group, the SDK will not provide "Push+Landing" campaigns to your application.

If you want to use and share the same **Device Id** on each of your applications you can also provide a [**Keychain Group Name**](# Keychain sharing).

Now open your's AppDelegate class file and import the **GrowSDK** framework.

```swift
import GrowSDK
```

In the same file find the method `application(_:didFinishLaunchingWithOptions:)` and on it create a **Configuration** object from the GrowSDK framework. This object receives a lambda function to provide the possible configurations to be used on the initialization of SDK.

Having this object created you now pass it to the static method `start(_:options:)` of the main class `Grow` of the SDK. This static method also requires the launchOptions.

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let configuration = Grow.Configuration(apiKey: "\(API_Key)", configuration: { configs in
        configs.appGroup = "\(App_Group_Name)"
        configs.keychainGroupName = "\(Team_Id).\(Keychain_Group_Name)"
    })
    Grow.start(configuration: configuration, options: launchOptions)
    ...
    return true
}
```

### Setup the SDK on the Extension

In order to handle Grow Push campaigns, you must add a **Notification Service** extension to your app. This extension should extends our `GrowNotificationService` class instead of the Apple `UNNotificationServiceExtension`. Then you need to implement the `configuration()` method to setup the Grow SDK on the extension.

Your notification service extension class should look like this.

```swift
import UserNotifications
import GrowSDK

class NotificationService: UNNotificationServiceExtension {
    var service: GrowNotificationService?
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        let configuration = Grow.ExtensionConfiguration(apiKey: "\(API_Key)", extensionConfiguration: { configs in
            configs.appGroup = "\(App_Group_Name)"
            configs.keychainGroupName = "\(Team_Id).\(Keychain_Group_Name)"
        })
        service = Grow.didReceive(request, forConfiguration: configuration, withContentHandler: contentHandler)
    }
    override func serviceExtensionTimeWillExpire() {
        service?.serviceExtensionTimeWillExpire()
    }
}
```

If you need to implement the `didReceive(_:withContentHandler:)` method on your **Notification Service** extension, you must ensure to forward the call before your code.

## Xcode Signing & Capabilities

In order to make the SDK fully functional, it requires the developer to configure capabilities on the application target and as well on the extension target.

#### Push Notifications

This capability needs to be added to the application target. And to add it you need to select your application target and then select the option `Signing & Capabilities`. From there tap on the button `+ Capability`.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/capability_step_1.png">

On the prompt, you search for **Push Notifications** and add this capability.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/push_step_2.png">

The capability should now be on your application target.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/push_step_3.png">

#### Background Modes

In order for the SDK to be able to process and prepare content in the background, it requires background modes to be added as well on the application side. To do this you need to select your application target and then select the option `Signing & Capabilities`. From there tap on the button `+ Capability`. The same way you did before.

Then on the prompt, you search for **Background Modes** and add this capability.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/bkg_step_1.png">

On the Background Modes section of the target, you need to enable `Background fetch`, `Remote notifications`, and `Background processing`.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/bkg_step_2.png">

#### App Group

This capability needs to be added to both targets, application, and extension. To do that you select the target and then select the option `Signing & Capabilities`. From there tap on the button `+ Capability`.  The same way you did before.

Then on the prompt, you search for **App Group** and add this capability.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/app_group_step_2.png">

On the App Group section of the target, you tap on the **[ + ]** to add a new container.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/app_group_step_3.png">

A prompt is displayed and on that, you type the name you want to use. This name will be the one you need to pass on the **configs.appGroup** of the **Grow SDK** configuration object.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/app_group_step_4.png">

If you have auto signing Xcode will update the profiles automatically, if not you need to access the [Apple Certificates](https://developer.apple.com/account/resources/certificates/list) website and update them with this new capability.

The App Group name you type should now be passed from red to black as shown below.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/app_group_step_5.png">

**Now you repeat these steps with the exact same `App Group` name on your Extension target.**

#### Keychain sharing

This capability allows the SDK to share the same **Device Id** across different applications of the same owner. And as well if configured on the application side it is mandatory to be configured as well on the extension side.

To add this capability you select your application target and then select the option `Signing & Capabilities`. From there tap on the button `+ Capability`. The same way you did before.

Then on the prompt, you search for **Keychain sharing** and add this capability.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/keychain_step_2.png">

On the Keychain Sharing section of the target, you tap on the **[ + ]** to add a new container and type the name you want to use. This name will be the one you need to pass on the **configs.keychainGroupName** of the **Grow SDK** configuration object.

<img src="https://bryj-sdks.s3.eu-west-1.amazonaws.com/grow/docs/iOS/keychain_step_4.png">

**Now you repeat these steps with the exact same `Keychain Group Name` on your Extension target.**

