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
    // Register with ContextHub
#ifdef DEBUG
    // The debug flag is automatically set by the compiler, indicating which push gateway server your device will use
    // Xcode deployed builds use the sandbox/development server
    // TestFlight/App Store builds use the production server
    // ContextHub records which environment a device is using so push works properly
    // This must be called BEFORE [ContextHub registerWithAppId:]
    [[ContextHub sharedInstance] setDebug:TRUE];
#endif
    
    //Register the app id of the application you created on https://app.contexthub.com
    [ContextHub registerWithAppId:@"YOUR-PUSH-APP-ID-HERE"];
    
    // Register for remote notifications
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound ];
    
    // Clear badge
    application.applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Clear badge
    application.applicationIconBadgeNumber = 0;
}
							
#pragma mark - Remote Notifications

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
    
    // Define our fetch completion handler which is called by ContextHub if the push wasn't a push for CCHSubscriptionService
    void (^fetchCompletionHandler)(UIBackgroundFetchResult) = ^(UIBackgroundFetchResult result){
        NSLog(@"Push received: %@", userInfo);
        NSString *message = [userInfo valueForKeyPath:@"aps.alert"];
        NSDictionary *customPayload = [userInfo valueForKey:@"payload"];
        BOOL background = ([userInfo valueForKeyPath:@"aps.content-available"] != nil) ? YES : NO;
        
        // Add the message to our store
        NMPushNotification *newNotification = [[NMPushNotification alloc] initWithAlert:message customPayload:customPayload background:background];
        [[NMPushNotificationStore sharedInstance] addNotification:newNotification];
        
        // Pop an alert about our message only if our app is in the foreground and push wasn't from background
        if (application.applicationState == UIApplicationStateActive && !background) {
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
        
        // Increase badge number by 1
        application.applicationIconBadgeNumber += 1;
        
        // Post a notification that there's a new push notification so our receive table view can reload data
        [[NSNotificationCenter defaultCenter] postNotificationName:NMNewPushNotification object:nil];
        
        // Call the completionhandler based on whether your push resulted in data or not 
        completionHandler(UIBackgroundFetchResultNewData);
    };
    
    // Let ContextHub process the push
    [[CCHPush sharedInstance] application:application didReceiveRemoteNotification:userInfo completionHandler:fetchCompletionHandler];
}

@end