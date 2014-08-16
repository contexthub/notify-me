//
//  NMReceiveDetailTableViewController.m
//  NotifyMe
//
//  Created by Jeff Kibuule on 8/15/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "NMReceiveDetailTableViewController.h"

#import "NMPushNotification.h"

@interface NMReceiveDetailTableViewController ()

@property (nonatomic, weak) IBOutlet UILabel *alertLabel;
@property (nonatomic, weak) IBOutlet UILabel *payloadLabel;
@property (nonatomic, weak) IBOutlet UILabel *backgroundLabel;
@property (nonatomic, weak) IBOutlet UILabel *timestampLabel;

@end

@implementation NMReceiveDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup view
    self.alertLabel.text = self.notification.background ? @"None" : self.notification.alert;
    self.payloadLabel.text = self.notification.payload[@"text"] ? self.notification.payload[@"text"] : @"None";
    self.backgroundLabel.text = self.notification.background ? @"Yes" : @"No";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    
    self.timestampLabel.text = [dateFormatter stringFromDate:self.notification.timeReceivedDate];
}

@end