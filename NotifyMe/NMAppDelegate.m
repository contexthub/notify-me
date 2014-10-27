//
//  NMAppDelegate.m
//  NotifyMe
//
//  Created by Jeff Kibuule on 8/12/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "NMAppDelegate.h"
#import <ContextHub/ContextHub.h>

#import "NMPushNotification.h"
#import "NMPushNotificationStore.h"
#import "NMConstants.h"

@implementation NMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef DEBUG
    // The debug flag is automatically set by the compiler, indicating which push gateway server your device will use
    // Xcode deployed builds use the sandbox/development server
    // TestFlight/App Store builds use the production server
    // ContextHub records which environment a device is using so push works properly
    // This must be called BEFORE [ContextHub registerWithAppId:]
    [[ContextHub sharedInstance] setDebug:TRUE];
#endif
    
    // Register the app id of the application you created on https://app.contexthub.com
    [ContextHub registerWithAppId:@"YOUR-PUSH-APP-ID-HERE"];
    
    // Register for remote notifications
    if ([UIUserNotificationSettings class]) {
        // iOS 8 and above
        UIUserNotificationType notificationTypes = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 7 and below
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
    // Clear badge
    application.applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Clear badge
    application.applicationIconBadgeNumber = 0;
}
							
#pragma mark - Remote Notifications

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // Register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    // Handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    } else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Set up the alias, tags, and register for push notifications on the server
    NSString *alias = [[UIDevice currentDevice] name];
    NSArray *tags = @[NMDeviceFirstTag, NMDeviceSecondTag];
    
    [[CCHPush sharedInstance] registerDeviceToken:deviceToken alias:alias tags:tags completionHandler:^(NSError *error) {
        
        if (!error) {
            // Build tag string
            __block NSString *tagString = tags[0];
            [tags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                // Skip over the first time
                if (idx != 0) {
                    tagString = [tagString stringByAppendingString:[NSString stringWithFormat:@", %@", obj]];
                }
            }];
            
            NSLog(@"Successfully registered device with alias %@ and tags %@", [[UIDevice currentDevice] name], tagString);
        }
        else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did fail to register %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Define our fetchCompletionHandler which is called after ContextHub processes our push
    void (^fetchCompletionHandler)(UIBackgroundFetchResult, BOOL) = ^(UIBackgroundFetchResult result, BOOL CCHContextHubPush){
        
        if (CCHContextHubPush) {
            // ContextHub processed this push, just call the Apple completionHandler
            completionHandler (result);
        } else {
            // This push was for our app to process
            NSLog(@"Push received: %@", userInfo);
    
            NSString *message = [userInfo valueForKeyPath:@"aps.alert"];
            NSDictionary *customPayload = [userInfo valueForKey:@"payload"];
            BOOL background = ([userInfo valueForKeyPath:@"aps.content-available"] != nil) ? YES : NO;
            
            // Add the message to our store
            NMPushNotification *newNotification = [[NMPushNotification alloc] initWithAlert:message customPayload:customPayload background:background];
            [[NMPushNotificationStore sharedInstance] addNotification:newNotification];
            
            // Increase badge number by 1
            application.applicationIconBadgeNumber += 1;
            
            // Pop an alert about our message only if our app is in the foreground and push wasn't from background
            if (application.applicationState == UIApplicationStateActive && !background) {
                [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                
                application.applicationIconBadgeNumber = 0;
            }
            
            // Post a notification that there's a new push notification so our receive table view can reload data
            [[NSNotificationCenter defaultCenter] postNotificationName:NMNewPushNotification object:nil];
            
            // Call the completionhandler based on whether your push resulted in data or not
            completionHandler(UIBackgroundFetchResultNewData);
        }
    };
    
    // Let ContextHub process the push
    [[CCHPush sharedInstance] application:application didReceiveRemoteNotification:userInfo completionHandler:fetchCompletionHandler];
}

@end