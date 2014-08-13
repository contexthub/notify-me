//
//  NMPushNotification.h
//  NotifyMe
//
//  Created by Jeff Kibuule on 8/13/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMPushNotification : NSObject

@property (nonatomic, copy) NSString *alert;
@property (nonatomic, strong) NSDictionary *customPayload;

@end