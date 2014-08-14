//
//  NMPushNotification.m
//  NotifyMe
//
//  Created by Jeff Kibuule on 8/13/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "NMPushNotification.h"

@implementation NMPushNotification

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _alert = @"";
        _customPayload = [NSDictionary dictionary];
        _timeReceivedDate = [NSDate date];
        
        return self;
    }
    
    return nil;
}

@end