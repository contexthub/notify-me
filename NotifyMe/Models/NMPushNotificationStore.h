//
//  NMPushNotificationStore.h
//  NotifyMe
//
//  Created by Jeff Kibuule on 8/14/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NMPushNotification;

@interface NMPushNotificationStore : NSObject

@property (nonatomic, strong) NSMutableArray *notifications;

+ (instancetype)sharedInstance;

@end
