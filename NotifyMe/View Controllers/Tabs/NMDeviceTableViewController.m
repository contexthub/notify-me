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

typedef NS_ENUM(NSUInteger, NMDeviceSection) {
    NMDeviceSectionAlias = 0,
    NMDeviceSectionTags,
    NMDeviceSectionDevice
};

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
        case NMDeviceSectionAlias:
            
            return 1;
        case NMDeviceSectionTags:
            
            return self.tags.count;
        case NMDeviceSectionDevice:
            
            return 1;
        default:
            
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case NMDeviceSectionAlias:
            
            return @"Alias";
        case NMDeviceSectionTags:
            
            return @"Tag(s)";
        case NMDeviceSectionDevice:
            
            return @"Device ID";
        default:
            
            return @"";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (section == NMDeviceSectionDevice) {
        return @"Device id will not change after it has been assigned from ContextHub";
    }
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NMDeviceTableViewCellIdentifier" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case NMDeviceSectionAlias:
            cell.textLabel.text = [[UIDevice currentDevice] name];
            
            break;
        case NMDeviceSectionTags:
            cell.textLabel.text = self.tags[indexPath.row];
            
            
            break;
        case NMDeviceSectionDevice:
            cell.textLabel.text = [ContextHub deviceId];
            
            break;
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
        case NMDeviceSectionAlias:
            stringCopied = [[UIDevice currentDevice] name];
            
            break;
        case NMDeviceSectionTags:
            stringCopied = self.tags[indexPath.row];
            
            break;
        case NMDeviceSectionDevice:
            stringCopied = [ContextHub deviceId];
            
            break;
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