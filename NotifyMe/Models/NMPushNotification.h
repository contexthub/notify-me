//
//  NMPushNotification.h
//  NotifyMe
//
//  Created by Jeff Kibuule on 8/13/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMPushNotification : NSObject <NSCoding>

@property (nonatomic, copy) NSString *alert;
@property (nonatomic, copy) NSDictionary *payload;
@property (nonatomic) BOOL background;
@property (nonatomic, strong) NSDate *timeReceivedDate;

- (instancetype)initWithAlert:(NSString *)alert customPayload:(NSDictionary *)customPayload background:(BOOL)background;

@end