//
//  NMPushNotification.m
//  NotifyMe
//
//  Created by Jeff Kibuule on 8/13/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "NMPushNotification.h"

@implementation NMPushNotification

- (instancetype)initWithAlert:(NSString *)alert customPayload:(NSDictionary *)customPayload background:(BOOL)background {
    self = [super init];
    
    if (self) {
        _alert = alert;
        _customPayload = customPayload;
        _backgroundPushNotification = background;
        _timeReceivedDate = [NSDate date];
        
        return self;
    }
    
    return nil;
}

@end