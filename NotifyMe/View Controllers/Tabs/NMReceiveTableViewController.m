//
//  NMReceiveTableViewController.m
//  NotifyMe
//
//  Created by Jeff Kibuule on 8/13/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "NMReceiveTableViewController.h"

#import "NMPushNotification.h"
#import "NMPushNotificationStore.h"

#import "NMReceiveTableViewCell.h"

@interface NMReceiveTableViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation NMReceiveTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterLongStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [[NMPushNotificationStore sharedInstance].notifications count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NMReceiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NMReceiveTableViewCellIdentifier" forIndexPath:indexPath];
    NMPushNotification *notification = [NMPushNotificationStore sharedInstance].notifications[indexPath.row];
    
    // Configure the cell...
    cell.alertLabel.text = [NSString stringWithFormat:@"Alert: %@", notification.alert];
    
    NSString *customPayloadText = notification.customPayload ? @"Yes" : @"No";
    cell.customPayloadLabel.text = [NSString stringWithFormat:@"Custom payload: %@", customPayloadText];
    cell.timeStampLabel.text = [self.dateFormatter stringFromDate:notification.timeReceivedDate];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end