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
    // This tells ContextHub that you are running a debug build.
    [[ContextHub sharedInstance] setDebug:TRUE];
#endif
    
    //Register the app id of the application you created on https://app.contexthub.com
    //[ContextHub registerWithAppId:@"YOUR-PUSH-APP-ID-HERE"];
    [ContextHub registerWithAppId:@"4e0aad2a-b052-42e0-93ee-6f024d11de10"];
    
    // Register for remote notifications
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound ];
    
    return YES;
}
							
#pragma mark - Remote Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Set up the alias, tag, and register for push notifications on the server
    NSString *alias = [[UIDevice currentDevice] name];
    NSString *tag = NMDeviceTag;
    
    [[CCHPush sharedInstance] registerDeviceToken:deviceToken alias:alias tags:@[tag] completionHandler:^(NSError *error) {
        if (!error) {
            NSLog(@"Successfully registered device with alias %@ and tags %@", [[UIDevice currentDevice] name], tag);
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
        NSDictionary *customPayload = [userInfo valueForKeyPath:@"aps.customPayload"];
        BOOL background = [userInfo valueForKey:@"content-available"] ? YES : NO;
        
        // Add the message to our store
        NMPushNotification *newNotification = [[NMPushNotification alloc] initWithAlert:message customPayload:customPayload background:background];
        [[NMPushNotificationStore sharedInstance].notifications addObject:newNotification];
        
        // Pop an alert about our message
        [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        
        // Call the completionhandler based on whether your push resulted in data or not 
        completionHandler(UIBackgroundFetchResultNewData);
    };
    
    // Let ContextHub process the push
    [[CCHPush sharedInstance] application:application didReceiveRemoteNotification:userInfo completionHandler:fetchCompletionHandler];
}

@end