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

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _alert = [aDecoder decodeObjectForKey:@"alert"];
        _customPayload = [aDecoder decodeObjectForKey:@"payload"];
        _backgroundPushNotification = [aDecoder decodeBoolForKey:@"background"];
        _timeReceivedDate = [aDecoder decodeObjectForKey:@"time"];
        
        return self;
    }
    
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.alert forKey:@"alert"];
    [aCoder encodeObject:self.customPayload forKey:@"payload"];
    [aCoder encodeBool:self.backgroundPushNotification forKey:@"background"];
    [aCoder encodeObject:self.timeReceivedDate forKey:@"time"];
}

@end