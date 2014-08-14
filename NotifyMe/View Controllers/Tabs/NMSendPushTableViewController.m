//
//  NMSendPushTableViewController.m
//  NotifyMe
//
//  Created by Jeff Kibuule on 8/13/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "NMSendPushTableViewController.h"
#import <ContextHub/ContextHub.h>

@interface NMSendPushTableViewController ()


typedef NS_ENUM(NSUInteger, NMPushType) {
    NMPushTypeDeviceID = 0,
    NMPushTypeAlias,
    NMPushTypeTag
};

@property (nonatomic) NSUInteger selectedIndex;

@property (nonatomic, strong) IBOutletCollection(UITableViewCell) NSArray *cells;
@property (nonatomic, weak) IBOutlet UITextField *alertTextField;
@property (nonatomic, weak) IBOutlet UITextField *devicesTextField;
@property (nonatomic, weak) IBOutlet UITextField *customPayloadTextField;

@end

@implementation NMSendPushTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Select devices by default
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Push Methods

// Send a message to a device
- (void)pushMessage:(NSString *)message toDeviceID:(NSString *)deviceID {
    NSDictionary *userInfo = @{ @"alert":message, @"sound":@"default" };
    [[CCHPush sharedInstance] sendNotificationToDevices:@[deviceID] userInfo:userInfo completionHandler:^(NSError *error) {
        
        if (!error) {
            NSString *alertMessage = [NSString stringWithFormat:@"Push sent successfully to device id: %@", deviceID];
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            NSLog(@"NM: Push successfully sent to device id: %@", deviceID);
        } else {
            NSString *alertMessage = [NSString stringWithFormat:@"Push failed to send to device id: %@", deviceID];
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            NSLog(@"NM: Push failed to send to device id '%@' with error: %@", deviceID, error);
        }
    }];
}

// Send a message to aliases
- (void)pushMessage:(NSString *)message toAliases:(NSString *)aliases {
    NSDictionary *userInfo = @{ @"alert":message, @"sound":@"default" };
    
    NSString *aliasesWithoutWhitespace = [aliases stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *aliasesArray = [aliasesWithoutWhitespace componentsSeparatedByString:@","];
    [[CCHPush sharedInstance] sendNotificationToAliases:aliasesArray userInfo:userInfo completionHandler:^(NSError *error) {
        
        if (!error) {
            NSString *alertMessage = [NSString stringWithFormat:@"Push sent successfully to aliases: %@", aliasesWithoutWhitespace];
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            NSLog(@"NM: Push successfully sent to aliases: %@", aliasesWithoutWhitespace);
        } else {
            NSString *alertMessage = [NSString stringWithFormat:@"Push failed to send to aliases: %@", aliasesWithoutWhitespace];
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            NSLog(@"NM: Push failed to send to aliases '%@' with error: %@", aliasesWithoutWhitespace, error);
        }
    }];
}

// Send a message to tags
- (void)pushMessage:(NSString *)message toTags:(NSString *)tags {
    NSDictionary *userInfo = @{ @"alert":message, @"sound":@"default" };
    
    NSString *tagsWithoutWhitespace = [tags stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *tagsArray = [tagsWithoutWhitespace componentsSeparatedByString:@","];
    [[CCHPush sharedInstance] sendNotificationToTags:tagsArray userInfo:userInfo completionHandler:^(NSError *error) {
        
        if (!error) {
            NSString *alertMessage = [NSString stringWithFormat:@"Push sent successfully to tags: %@", tagsWithoutWhitespace];
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            NSLog(@"NM: Push successfully sent to tags: %@", tagsWithoutWhitespace);
        } else {
            NSString *alertMessage = [NSString stringWithFormat:@"Push failed to send to tags: %@", tagsWithoutWhitespace];
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            NSLog(@"NM: Push failed to send to tags '%@' with error: %@", tagsWithoutWhitespace, error);
        }
    }];
}

#pragma mark - Actions

- (IBAction)sendPush:(id)sender {
    
    switch (self.selectedIndex) {
        case NMPushTypeDeviceID:
        {
            // Convert device ID to NSUUID, if that fails, not a valid device ID
            NSUUID *deviceID = [[NSUUID alloc] initWithUUIDString:self.devicesTextField.text];
            
            if (deviceID) {
                [self pushMessage:self.alertTextField.text toDeviceID:deviceID.UUIDString];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Device id is not a valid" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            }
            
            break;
        }
        case NMPushTypeAlias:
        {
            [self pushMessage:self.alertTextField.text toAliases:self.devicesTextField.text];
            
            break;
        }
        case NMPushTypeTag:
        {
            [self pushMessage:self.alertTextField.text toTags:self.devicesTextField.text];
            
            break;
        }
        default:
            
            break;
    }
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        for (UITableViewCell *currCell in self.cells)
        {
            currCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        self.selectedIndex = indexPath.row;
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end