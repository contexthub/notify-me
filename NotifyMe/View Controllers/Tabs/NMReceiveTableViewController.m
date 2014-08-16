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

#import "NMReceiveDetailTableViewController.h"

#import "NMConstants.h"

@interface NMReceiveTableViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation NMReceiveTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the timestamp style
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    
    // Listen to notifications about new push notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newNotification:) name:NMNewPushNotification object:nil];
}

#pragma mark - Actions

- (IBAction)clearNotifications:(id)sender {
    [[NMPushNotificationStore sharedInstance] deleteNotifications];
    [self.tableView reloadData];
}

#pragma mark - Events

- (void)newNotification:(NSNotification *)notification {
    [self.tableView reloadData];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[NMPushNotificationStore sharedInstance].notifications count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Notifications";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NMReceiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NMReceiveTableViewCellIdentifier" forIndexPath:indexPath];
    NMPushNotification *notification = [NMPushNotificationStore sharedInstance].notifications[indexPath.row];
    
    NSString *alertText = notification.alert ? notification.alert : @"None";
    NSString *payloadText = notification.payload ? @"Yes" : @"No";
    NSString *backgroundText = notification.background ? @"Yes" : @"No";
    
    cell.alertLabel.text = [NSString stringWithFormat:@"Alert: %@", alertText];
    cell.payloadLabel.text = [NSString stringWithFormat:@"Custom payload: %@", payloadText];
    cell.backgroundLabel.text = [NSString stringWithFormat:@"Background: %@", backgroundText];
    cell.timeStampLabel.text = [self.dateFormatter stringFromDate:notification.timeReceivedDate];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"detailNotificationSegue"]) {
        NMReceiveDetailTableViewController *detailVC = (NMReceiveDetailTableViewController *)segue.destinationViewController;
        NSUInteger selectedIndex = [self.tableView indexPathForSelectedRow].row;
        detailVC.notification = [NMPushNotificationStore sharedInstance].notifications[selectedIndex];
    }
}

@end