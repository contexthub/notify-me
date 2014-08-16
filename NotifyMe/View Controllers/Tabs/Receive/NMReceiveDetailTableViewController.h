//
//  NMReceiveDetailTableViewController.h
//  NotifyMe
//
//  Created by Jeff Kibuule on 8/15/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NMPushNotification;

@interface NMReceiveDetailTableViewController : UITableViewController

@property (nonatomic, weak) NMPushNotification *notification;

@end