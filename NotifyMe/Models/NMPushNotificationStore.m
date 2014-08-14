//
//  NMPushNotificationStore.m
//  NotifyMe
//
//  Created by Jeff Kibuule on 8/14/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "NMPushNotificationStore.h"

@interface NMPushNotificationStore ()

@end

@implementation NMPushNotificationStore

static NMPushNotificationStore * __instance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[NMPushNotificationStore alloc] init];
    });
    
    return __instance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _notifications = [NSMutableArray array];
        
        return self;
    }
    
    return nil;
}

@end