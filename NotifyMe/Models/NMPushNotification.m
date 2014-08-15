//
//  NMPushNotification.m
//  NotifyMe
//
//  Created by Jeff Kibuule on 8/13/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "NMPushNotification.h"

@implementation NMPushNotification

- (instancetype)initWithAlert:(NSString *)alert customPayload:(NSDictionary *)payload background:(BOOL)background {
    self = [super init];
    
    if (self) {
        _alert = alert;
        _payload = payload;
        _background = background;
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
        _payload = [aDecoder decodeObjectForKey:@"payload"];
        _background = [aDecoder decodeBoolForKey:@"background"];
        _timeReceivedDate = [aDecoder decodeObjectForKey:@"time"];
        
        return self;
    }
    
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.alert forKey:@"alert"];
    [aCoder encodeObject:self.payload forKey:@"payload"];
    [aCoder encodeBool:self.background forKey:@"background"];
    [aCoder encodeObject:self.timeReceivedDate forKey:@"time"];
}

@end