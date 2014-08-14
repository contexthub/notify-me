//
//  NMSendPushTableViewController.m
//  NotifyMe
//
//  Created by Jeff Kibuule on 8/13/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "NMSendPushTableViewController.h"

@interface NMSendPushTableViewController ()

@property (nonatomic, weak) IBOutlet UITextView *alertTextView;

@end

@implementation NMSendPushTableViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

@end