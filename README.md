# Notify Me (Push) Sample app

The Notify Me sample app that introduces you to the push features of the ContextHub iOS SDK.

### Table of Contents

1. **[Purpose](#purpose)**
2. **[ContextHub](#contexthub)**
3. **[Background](#background)**
4. **[Getting Started](#getting-started)**
5. **[Setup](#setup)**
6. **[Running the Sample App](#running-the-sample-app)**
7. **[Xcode Console](#xcode-console)**
8. **[Sample Code](#sample-code)**
9. **[Usage](#usage)**
10. **[Troubleshooting](#troubleshooting)**

## Purpose

This sample application will show you how to send and receive foreground and background push notifications in ContextHub.

## ContextHub

In this sample application, we use ContextHub to interact with Apple Push Notification Services so we can send push notifications to devices based on their device ID, alias, or tag. ContextHub takes care of translating each of those items to a push token which APNS needs to send the message to the correct device.

## Background

Push notifications allows you to increase user engagement with your application through timely alerts that a user can directly tap on to launch your app. In iOS 7, this feature is greatly expanded with "background" notifications which can silently wake up your app, do some processing (30 second limitation) then go back to sleep so that the next time the user opens your app, it is filled with fresh content. This enables new kinds of scenarios and applications not possible before.

Rather than sending push notifications to tokens which Apple gives you (which can change at any time), ContextHub let's you deal with higher level concepts such as device ids, aliases, and tags:

1. A device ID is a 32-hexadecimal character string that is uniquely tied to a device. It will remain the same for the life of the app, and is based on the device, app id, and bundle id. 
2. Aliases are a friendlier version of the device ID, though they do not need to be unique. Each device is resticted to only one alias, but multiple devices can have the same alias. A great use of aliases is to indicate all the devices that belong to the single person by setting the alias to be the same SHA1 hashed email address.
3. Lastly, tags let you put devices into different groups. A single device can have multiple tags (vs. one alias per device), which give you as a developer more control over which devices get which notifications without explicitly needing to know all the specific device IDs which will receive the notification.

## Getting Started

1. Get started by either forking or cloning the Notify Me repo. Visit [GitHub Help](https://help.github.com/articles/fork-a-repo) if you need help.
2. Go to [ContextHub](http://app.contexthub.com) and create a new DetectMe application.
3. Find the app id associated with the application you just created. Its format looks something like this: `13e7e6b4-9f33-4e97-b11c-79ed1470fc1d`.
4. Open up your Xcode project and put the app id into the `[ContextHub registerWithAppId:]` method call.
5. You are now ready to setup push notifications with your device.

## Setup

1. Setting up push notifications can be a difficult process. There are several guides on the Internet to generate a .p12 file correctly, with (this one)[https://parse.com/tutorials/ios-push-notifications] from Parse having clear images as a guide in case you get lost.
2. The next step in setting up push notifications is generating a .p12 file which has both your private key and certificate needed by APNS. We will be doing this twice as the development APNS (and associated keys/certs) are separate from the production APNS (with different keys and certs).  When exporting in Keychain, make sure you select both the private key and certificate to export into a single file as ContextHub needs both. Save the file as "Certificates.p12".
3. With a .p12 file in a folder, navigate using Terminal into that folder and run the following command: 
```
openssl pkcs12 -in Certificates.p12 -out certificate.pem -nodes -clcerts
```
4. A `certificate.pem` should have been generated which you can open up in any text editor like TextEdit to be copy and pasted into the Settings page of your ContextHub app. The code should look something like this:
`Bag Attributes
    friendlyName: Apple Production IOS Push Services: YOUR-BUNDLE-ID-HERE`
and end like this
`-----END RSA PRIVATE KEY-----`
5. Paste the text you got from the certificate.pem into the appropriate certificate box (either sandbox/development or production). You can verify that you have created the correct keys and certs by the presence of the phrase `Apple Development IOS Push Services` for sandbox and `Apple Production IOS Push Services` for production.
6. Build and run your app on your device. You should get a popup notification asking for permission to receive push notifications if everything is working properly. If you have any issues, see the troubleshooting below.

## Running the sample app

1. Run the app on your device, you should get a popup asking to receive remote notifications at least once to know that registering for push was successfull.
2. On the send tab, tap on the "message" field and type in a short message.
3. By default, the app will send a message to your device id in the foreground. Try it now, tap send in the upper right hand corner, and you should receive an alert view when your message is received.
4. On the receive tab, you should see your notification appear and whether it was a foreground/background push, if it had a custom payload, and what time it was receieved. Tap the row to see more detail.
4. Now tap the device tab to see what your current alias and tags are. Tap on your alias (which in this app is your device name) to automatically copy it to your clipboard.
5. Go back to the send tab and replace your device id with your alias. Send another message.
6. You should recent another message when the alert is received from APNS.
7. Lastly, try sending a message to a tag by going to the device tab, tapping a tag to copy it to your pasteboard, then selecting "tags" in the type section and pasting your tag into the next section. Tap the switch button on the bottom to instead send a background notification instead of a foreground notification. Now tap send.
8. You shouldn't see a message appear, but when you go to the receive tap, a new message should be present. If you repeat step 7 again, but immediately press the home button after sending your message, you should hear your device alert or buzz stating you got a new message.
9. Background messaging can better tested if you send messages by running the app in the simulator and sending pushes to your device while the app on your device isn't running. You will see the badge count increase and your device will alert/buzz, which lets you know a message was processed.

## Xcode Console

1. This sample app will log push notification responses from Apple Push Notification Services so you can get an idea of the structure of the item you receive. Use shortcut `Shift-⌘-Y` if your console is not already visible.
2. A simple foreground push notification looks like this:
```
{
    aps =     {
        alert = message;
        sound = default;
    };
}
```
A push notification with a custom payload looks like this:
```
{
    aps =     {
        alert = push;
        sound = default;
    };
    payload =     {
        text = payload;
    };
}
```
A background push notification that will trigger your app to wake up will look like this:
```
{
    aps =     {
        "content-available" = 1;
        sound = default;
    };
}
```

## Sample Code

In this sample, most of the important code that deals with push notifications occurs in `NMAppDelegate.m` and `NMSendPushTableViewController.m`. `NMAppDelegate.m` deals with registering a device with APNS, registering the token, alias and tags with ContextHub and receiving push notifications. `NMSendPushTableViewController.m` handles sending push notifications in 3 different ways, to a device id, to multiple aliases, and to multiple tags.

In addition, `NMReceiveTableViewController.m` and `NMReceiveDetailTableViewController.m` deal with showing notifications that you have received with their contents; whether they were foreground or background pushes, the time they were received (which has no guarantee of immediacy with background pushes in relation to the time they were sent) and any custom payloads to be sent with the message. Key to this is the fact that the method:
```
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
``` 
will be called eventually with background notifications regardless of whether your application is in the foreground or background or not running at all, which gives added power to your applications to respond to a notification with a fresh state the next time a user opens up your app.

## Usage

Below shows the basics of how the CCHPush class is used to send and receive push notifications:

##### Registering for push

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Register for remote notifications
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound ];
    
#ifdef DEBUG
    // The debug flag is automatically set by the compiler, indicating which push gateway server your device will use
    // Xcode deployed builds use the sandbox/development server
    // TestFlight/App Store builds use the production server
    // ContextHub records which environment a device is using so push works properly
    // This must be called BEFORE [ContextHub registerWithAppId:]
    [[ContextHub sharedInstance] setDebug:TRUE];
#endif

    [ContextHub registerWithAppId:@"YOUR-APP-ID-HERE"];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *alias = @"alias";
    NSArray *tags = @[@"tag1", @"tag2"];
    
    [[CCHPush sharedInstance] registerDeviceToken:deviceToken alias:alias tags:tags completionHandler:^(NSError *error) {
        
        if (!error) {
            NSLog(@"Successfully registered device with alias %@ and tags %@", alias, @"tag1, tag2");
        }
        else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did fail to register %@", error);
}
```

##### Setting up a push dictionary

```objc
// Set up a push dictionary
NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];

// Add a message (optional for background pushes if push has sound key)
userInfo[@"alert"] = @"alert";

// Add a sound (optional for background pushes if push has alert key)
userInfo[@"sound"] = @"default";

// Add custom data (optional)
// Additional data can be strings, arrays or dictionaries, but entire push message must fit in 256 bytes to be delivered
userInfo[@"string"] = @"string";
userInfo[@"array"] = @["arrayItem"];
userInfo[@"dictionary"] = @{@"key": @"value"};

// Background notification (optional, key not set in foreground pushes)
// Note: a background messge *must* have at least a sound or an alert key (they can be blank) or it will not be delivered
// Note: a background message has no guarantee of processing time like a foreground message does. iOS determines when a background push received
userInfo[@"content-available"] = @1;
```

##### Sending a push to device(s)

```objc
// Send a push to 2 devices with IDs defined below
// Note: All device IDs are UUIDs, if a deviceID is not a valid UUID, then it is not a valid device ID
// Note: userDict is the push dictionary, see above on how to set it up
NSString *deviceID1 = @"20984403-690A-4098-8557-73B763F1DFFB";
NSString *deviceID2 = @"151E57AF-7E87-400F-A1E0-63C9E7811376";
[[CCHPush sharedInstance] sendNotificationToDevices:@[deviceID1, deviceID2] userInfo:userInfo completionHandler:^(NSError *error) {
    
    if (!error) {
        NSLog("Push to device ids \"%@, %@\" sent successfully", deviceID1, deviceID2);
    } else {
        NSLog("Push to device ids \"%@, %@\" failed", deviceID1, deviceID2);
    }
}];
```

##### Sending a push to alias(es)

```objc
// Send a push notification to 2 devices, with aliases "Michael's iPhone 5s" and "Jeff's iPhone 5"
// Note: userDict is the push dictionary, see above on how to set it up
NSString *alias1 = @"Michael's iPhone 5s";
NSString *alias2 = @"Jeff's iPhone 5";
[[CCHPush sharedInstance] sendNotificationToAliases:@[alias1, alias2] userInfo:userInfo completionHandler:^(NSError *error) {
    
    if (!error) {
        NSLog("Push to aliases \"%@, %@\" sent successfully", alias1, alias2);
    } else {
        NSLog("Push to aliases \"%@, %@\" failed", alias1, alias2);
    }
}];
```

##### Sending a push to tags(s)

```objc
// Send a push notification to all devices with tags "tag1" and "tag2"
// Note: If a device has both "tag1" and "tag2", they will receive the same notification twice
// Note: userDict is the push dictionary, see above on how to set it up
NSString *tag1 = @"tag1";
NSString *tag2 = @"tag2";
[[CCHPush sharedInstance] sendNotificationToTags:@[tag1, tag2] userInfo:userInfo completionHandler:^(NSError *error) {
    
    if (!error) {
        NSLog("Push to tags \"%@, %@\" sent successfully", tag1, tag2);
    } else {
        NSLog("Push to tags \"%@, %@\" failed", tag1, tag2);
    }
}];
```

##### Receiving a push

```objc
// Receive a push notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Define our fetch completion handler which is called by ContextHub if the push wasn't a push for CCHSubscriptionService
    void (^fetchCompletionHandler)(UIBackgroundFetchResult) = ^(UIBackgroundFetchResult result){
        NSLog(@"Push received: %@", userInfo);

        // Get the alert (will be nil if it doesn't exist)
        NSString *alert = [userInfo valueForKeyPath:@"aps.alert"];
        
        // Determine if this was a background or foreground push based on presence of "content-available" key
        BOOL background = ([userInfo valueForKeyPath:@"aps.content-available"] != nil) ? YES : NO;
        
        // Get the custom data (we sent this ourselves in the userInfo dictionary)
        NSString *string = [userInfo valueForKey:@"string"];
        NSArray *array = [userInfo valueForKey:@"array"];
        NSDictionary *dictionary = [userInfo valueForKey:@"dictionary"];

        // At this point, you can act on the message by popping an alert view
        // Note that if this notification was processed in the background, check application state to avoid unnecessary UI alerts
        if (application.applicationState == UIApplicationStateActive) {
            // App in foreground
        }

        // Call the completionhandler based on whether your push resulted in data or not 
        completionHandler(UIBackgroundFetchResultNewData);
    };
    
    // Let ContextHub process the push
    [[CCHPush sharedInstance] application:application didReceiveRemoteNotification:userInfo completionHandler:fetchCompletionHandler];
}
```

That's it! Hopefully this sample application showed you how to work with push notifications in ContextHub to send and receive notifications to devices. With push setup, you no longer need to call `[[CCHSensorPipeline sharedInstance] synchronize]` so the sensor pipeline has the latest data to drive events. You can also move onto the subscription sample "watch-dog" which walks through how push let's your app be aware of create, update, and delete changes to elements (beacons, geofences) as well as vault items in near real-time.

## Troubleshooting

Things to check if you have not gotten a notification in your app asking to receive push notifications:

1. Ensure that you have the correct push certificates for your bundle identifier (ex. com.chaione.notifyme)
2. Ensure you are testing push on an iOS device. Push notifications do *not* work with the iOS Simulator and will always fail registration.
3. Ensure that you are *not* using a provisioning profile with a wildcard (`*`) in the bundle identifier (`com.chaione.*`). Team Provisioning Profiles auto-generated by Xcode will *not* work. Push notifications only work with full, explicit bundle identifiers (ex. `com.chaione.notifyme`) manually generated by memebers of your Apple Developer Program who have "Agent" status or higher. If you cannot make approve certificate signing requests on your own, talk to someone with "Agent" status or higher on your team to get them to approve them for you.
4. Ensure that the proper provisioning profile is used in project settings when deploying to a device. While an app will run on your device with a wildcard profile, it will only ask for permission to receive push notifications with a provisioning profile linked to a full, explicit bundle id (ex. `com.chaione.notifyme`)

Things to check if you are not receiving push notifications (you need to have gotten the Apple push alert first - it will only popup once per bundle id):

1. Make sure that the sandbox/production certificate and private keys are in the correct places
2. Check and make sure the device has a push token. If not, delete the device and try again (the record will be regenerated).
3. Check devices in the portal, find your device, and make sure that the push environment is "sandbox" for Xcode deployments and "production" for TestFlight/AppStore deployments. If it is not, see #5 for fix.
4. Note that apps which you have explicitly killed by swiping up from the multi-tasking menu will *never* get foreground or background notifications. This is by Apple's design due to their belief that a killed app should get no notifications until a user again explicitly interacts with the app by opening it up again.
5. Make sure that you have this piece of code called *before* you call [ContextHub registerAppId:]:
```objc
#ifdef DEBUG
    [[ContextHub sharedInstance] setDebug:TRUE];
#endif
```

Other:

1. Background pushes will be processed when iOS decides to process them. Usually this is immediate, but there is no guarantee, especially if your app has sent several background pushes but the fetchCompletionHandler has often gotten a result of UIBackgroundFetchResultNoNewData (note, simply using UIBackgroundFetchResultNewData does not help with increasing the immediacy of responding to a background notification immediately).
2. According to Apple docs, you should not worry about the number of background pushes you send to a device, they will automatically be rate-limited in being delivered to the device (see #3 for more info)
3. Background pushes can be queued at the APNS level and sent with the next foreground push if too many background pushes are sent at once.
4. There is no guarantee that a push notification will be delivered to a device, though APNS gives best effort when possible. If a device is offline when a push is sent, APNS will attempt to send it the next time the device is online.