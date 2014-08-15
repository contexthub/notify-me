//
//  NMDeviceTableViewController.m
//  NotifyMe
//
//  Created by Jeff Kibuule on 8/15/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "NMDeviceTableViewController.h"
#import <ContextHub/ContextHub.h>

#import "NMConstants.h"

@interface NMDeviceTableViewController ()

@property (nonatomic, strong) NSArray *tags;

@end

@implementation NMDeviceTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tags = @[NMDeviceFirstTag, NMDeviceSecondTag];
}

#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
        case 1:
            return 1;
        case 2:
            return self.tags.count;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"Device ID";
            break;
        case 1:
            return @"Alias";
            break;
        case 2:
            return @"Tag(s)";
            break;
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NMDeviceTableViewCellIdentifier" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = [ContextHub deviceId];
            break;
        }
            
        case 1:
        {
            cell.textLabel.text = [[UIDevice currentDevice] name];
            break;
        }
        case 2:
        {
            cell.textLabel.text = self.tags[indexPath.row];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.persistent = YES;
    NSString *stringCopied = @"";
    
    switch (indexPath.section) {
        case 0:
            stringCopied = [ContextHub deviceId];
            
            break;
        case 1:
            stringCopied = [[UIDevice currentDevice] name];
            break;
        case 2:
        {
            stringCopied = self.tags[indexPath.row];
            break;
        }
        default:
            break;
    }
    
    [pasteboard setString:stringCopied];
    
    // Pop an alert that something was copied
    NSString *stringMessage = [NSString stringWithFormat:@"\"%@\" was copied to the pasteboard", stringCopied];
    [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:stringMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end