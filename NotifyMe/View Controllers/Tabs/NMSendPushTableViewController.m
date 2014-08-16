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

typedef NS_ENUM(NSUInteger, NMSendPushSection) {
    NMSendPushSectionMessage = 0,
    NMSendPushSectionType,
    NMSendPushSectionDevice,
    NMSendPushSectionPayload,
    NMSendPushSectionBackground
};

typedef NS_ENUM(NSUInteger, NMPushType) {
    NMPushTypeDeviceID = 0,
    NMPushTypeAlias,
    NMPushTypeTag
};

@property (nonatomic) NSUInteger selectedIndex;

@property (nonatomic, strong) IBOutletCollection(UITableViewCell) NSArray *cells;
@property (nonatomic, weak) IBOutlet UITextField *messageTextField;
@property (nonatomic, weak) IBOutlet UITextField *devicesTextField;
@property (nonatomic, weak) IBOutlet UITextField *payloadTextField;
@property (nonatomic, weak) IBOutlet UISwitch *backgroundSwitch;

@end

@implementation NMSendPushTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIndex = 0;
    self.devicesTextField.text = [ContextHub deviceId];
    self.backgroundSwitch.on = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Select devices by default
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:1];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Helper Methods
- (NSDictionary *)buildUserInfo {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"sound"] = @"default";
    
    // If background, then don't have an alert (backgrounds can have alerts, it only affects whether the app will wake up)
    // Note: background pushes must have either the alert key or sound key (even if keys are "") or they will not be processed
    if (self.backgroundSwitch.on) {
        userInfo[@"content-available"] = @1;
    } else {
        userInfo[@"alert"] = self.messageTextField.text;
    }
    
    // Additional payloads can be strings, arrays or dictionaries, but entire push message must fit in 256 bytes to be delivered
    NSString *payloadText = [self.payloadTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![payloadText isEqualToString:@""]) {
        userInfo[@"payload"] = @{ @"text":self.payloadTextField.text };
    }
    
    return userInfo;
}

#pragma mark - Push Methods

// Send a message to a device
- (void)pushMessageToDeviceID:(NSString *)deviceID {
    NSDictionary *userInfo = [self buildUserInfo];
    NSString *pushType = self.backgroundSwitch.on ? @"Background" : @"Foreground";
    
    // Send the push
    [[CCHPush sharedInstance] sendNotificationToDevices:@[deviceID] userInfo:userInfo completionHandler:^(NSError *error) {
        
        if (!error) {
            NSString *alertMessage = [NSString stringWithFormat:@"%@ push sent successfully to device id: %@", pushType, deviceID];
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            NSLog(@"NM: %@ push successfully sent to device id: %@", pushType, deviceID);
        } else {
            NSString *alertMessage = [NSString stringWithFormat:@"%@ push failed to send to device id: %@", pushType, deviceID];
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            NSLog(@"NM: %@ push failed to send to device id '%@' with error: %@", pushType, deviceID, error);
        }
    }];
}

// Send a message to aliases
- (void)pushMessageToAliases:(NSString *)aliasesString {
    NSDictionary *userInfo = [self buildUserInfo];
    NSString *pushType = self.backgroundSwitch.on ? @"Background" : @"Foreground";
    
    // Turn the alias string into an array
    NSArray *aliasesArray = [aliasesString componentsSeparatedByString:@","];
    
    // Send the push
    [[CCHPush sharedInstance] sendNotificationToAliases:aliasesArray userInfo:userInfo completionHandler:^(NSError *error) {
        
        if (!error) {
            NSString *alertMessage = [NSString stringWithFormat:@"%@ push sent successfully to aliases: %@", pushType, aliasesString];
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            NSLog(@"NM: %@ push successfully sent to aliases: %@", pushType, aliasesString);
        } else {
            NSString *alertMessage = [NSString stringWithFormat:@"%@ push failed to send to aliases: %@", pushType, aliasesString];
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            NSLog(@"NM: %@ push failed to send to aliases '%@' with error: %@", pushType, aliasesString, error);
        }
    }];
}

// Send a message to tags
- (void)pushMessageToTags:(NSString *)tagsString {
    NSDictionary *userInfo = [self buildUserInfo];
    NSString *pushType = self.backgroundSwitch.on ? @"Background" : @"Foreground";
    
    // Turn the tags string into an array
    NSArray *tagsArray = [tagsString componentsSeparatedByString:@","];
    
    // Send the push
    [[CCHPush sharedInstance] sendNotificationToTags:tagsArray userInfo:userInfo completionHandler:^(NSError *error) {
        
        if (!error) {
            NSString *alertMessage = [NSString stringWithFormat:@"%@ push sent successfully to tags: %@", pushType, tagsString];
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            NSLog(@"NM: %@ push successfully sent to tags: %@", pushType, tagsString);
        } else {
            NSString *alertMessage = [NSString stringWithFormat:@"%@ Push failed to send to tags: %@", pushType, tagsString];
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            NSLog(@"NM: %@ push failed to send to tags '%@' with error: %@", pushType, tagsString, error);
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
                [self pushMessageToDeviceID:deviceID.UUIDString];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Device id is not a valid" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            }
            
            break;
        }
        case NMPushTypeAlias:
        {
            [self pushMessageToAliases:self.devicesTextField.text];
            
            break;
        }
        case NMPushTypeTag:
        {
            [self pushMessageToTags:self.devicesTextField.text];
            
            break;
        }
        default:
            
            break;
    }
}

#pragma mark - Table View Delegate Methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case NMSendPushSectionMessage:
            return @"Send message";
        case NMSendPushSectionType:
            return @"Type";
        case NMSendPushSectionDevice:
        {
            switch (self.selectedIndex) {
                case NMPushTypeDeviceID:
                    return @"Device ID";
                case NMPushTypeAlias:
                    return @"Aliases";
                case NMPushTypeTag:
                    return @"Tags";
                default:
                    return @"To ...";
                    break;
            }
            
            break;
        }
        case NMSendPushSectionPayload:
            return @"Custom payload";
        case NMSendPushSectionBackground:
            return @"Visibility";
        default:
            return @"";
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case NMSendPushSectionMessage:
            [self.messageTextField becomeFirstResponder];
            
            break;
        case NMSendPushSectionType:
        {
            // Loop through every cell in this section and mark the accessory as none (see storyboard IBOutletCollection)
            for (UITableViewCell *currCell in self.cells)
            {
                currCell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            self.selectedIndex = indexPath.row;
            
            // Selected row has checkmark
            UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            // Update placeholder text
            switch (self.selectedIndex) {
                case NMPushTypeDeviceID:
                    self.devicesTextField.placeholder = @"Device id";
                    
                    break;
                case NMPushTypeAlias:
                    self.devicesTextField.placeholder = @"Comma-separated aliases";
                    
                    break;
                case NMPushTypeTag:
                    self.devicesTextField.placeholder = @"Comma-separated tags";
                    
                    break;
                default:
                    self.devicesTextField.placeholder = @"";
                    
                    break;
            }
            
            // Reload table (triggers updating section name)
            [self.tableView reloadData];
            break;
        }
        case NMSendPushSectionDevice:
            [self.devicesTextField becomeFirstResponder];
            
            break;
        case NMSendPushSectionPayload:
            [self.payloadTextField becomeFirstResponder];
            
            break;
        default:
            
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end