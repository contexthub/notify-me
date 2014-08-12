//
//  NMTabBarController.m
//  Notify Me
//
//  Created by Jeff Kibuule on 8/4/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "NMTabBarController.h"

/**
 Tab bar indicies
 */
typedef NS_ENUM(NSUInteger, NMTabBarIndex) {
    NMTabBarSendIndex = 0,
    NMTabBarReceiveIndex,
    NMTabBarAboutIndex
};

@implementation NMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    // Initially selected tab bar icon needs to have selected images
    UITabBarItem *tabBarItem = self.tabBar.items[0];
    tabBarItem.image = [UIImage imageNamed:@"SendTabBarIcon"];
    tabBarItem.selectedImage = [UIImage imageNamed:@"SendSelectedTabBarIcon"];
}

// Selected tab bar item should have selected tab bar item icons
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    switch ([tabBarController selectedIndex]) {
        case NMTabBarSendIndex:
            viewController.tabBarItem.image = [UIImage imageNamed:@"SendTabBarIcon"];
            viewController.tabBarItem.selectedImage = [UIImage imageNamed:@"SendSelectedTabBarIcon"];
            
            break;
        case NMTabBarReceiveIndex:
            viewController.tabBarItem.image = [UIImage imageNamed:@"ReceiveTabBarIcon"];
            viewController.tabBarItem.selectedImage = [UIImage imageNamed:@"ReceiveSelectedTabBarIcon"];
            
            break;
        case NMTabBarAboutIndex:
            viewController.tabBarItem.image = [UIImage imageNamed:@"AboutTabBarIcon"];
            viewController.tabBarItem.selectedImage = [UIImage imageNamed:@"AboutSelectedTabBarIcon"];
            
            break;
        default:
            
            break;
    }
}

@end